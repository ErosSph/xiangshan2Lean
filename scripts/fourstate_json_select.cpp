// Private streaming JSON selector. Numbers cross the pipe as original lexemes.
// No netlist transformation; public audit/preflight/import remain authoritative.
#include <cstdio>
#include <cstdlib>
#include <string>
#include <stdexcept>
#include <iostream>

class Parser {
    unsigned char buffer[65536];
    size_t pos=0, size=0;
    unsigned long long offset=0;
    std::string *capture=nullptr;
    std::string prefix, mode;
    int peek() {
        if (pos==size) { size=std::fread(buffer,1,sizeof buffer,stdin); pos=0;
            if (!size && std::ferror(stdin)) fail("input read error"); }
        return pos<size ? buffer[pos] : EOF;
    }
    [[noreturn]] void fail(const std::string &s) { throw std::runtime_error(s+" at byte "+std::to_string(offset)); }
    int get(bool save=true) {
        int c=peek(); if(c==EOF) fail("unexpected EOF"); ++pos; ++offset;
        if(capture && save) capture->push_back(char(c));
        return c;
    }
    void ws() { while(peek()==' '||peek()=='\n'||peek()=='\r'||peek()=='\t') get(false); }
    void take(char c) { if(get()!=c) fail("unexpected token"); }
    static bool digit(int c) { return c>='0' && c<='9'; }
    static void utf8(std::string &s, unsigned n) {
        if(n<128) s+=char(n);
        else if(n<2048) {s+=char(192|(n>>6));s+=char(128|(n&63));}
        else if(n<65536) {s+=char(224|(n>>12));s+=char(128|((n>>6)&63));s+=char(128|(n&63));}
        else {s+=char(240|(n>>18));s+=char(128|((n>>12)&63));s+=char(128|((n>>6)&63));s+=char(128|(n&63));}
    }
    unsigned hex4() {
        unsigned n=0;
        for(int i=0;i<4;++i) {int c=get(); unsigned v;
            if(c>='0'&&c<='9')v=c-'0';else if(c>='a'&&c<='f')v=c-'a'+10;
            else if(c>='A'&&c<='F')v=c-'A'+10;else fail("bad unicode escape");
            n=n*16+v;}
        return n;
    }
    std::string string(bool decode) {
        take('"'); std::string s;
        while(true) {
            int c=get(); if(c=='"')break;
            if(c<32)fail("control character in string");
            if(c=='\\') {
                c=get(); unsigned n;
                switch(c) {
                    case '"':case '\\':case '/':break;
                    case 'b':c=8;break;case 'f':c=12;break;case 'n':c=10;break;
                    case 'r':c=13;break;case 't':c=9;break;
                    case 'u':
                        n=hex4();
                        if(n>=0xd800&&n<=0xdbff) {take('\\');take('u');unsigned low=hex4();
                            if(low<0xdc00||low>0xdfff)fail("bad surrogate pair");
                            n=0x10000+((n-0xd800)<<10)+(low-0xdc00);}
                        else if(n>=0xdc00&&n<=0xdfff)fail("unpaired surrogate");
                        if(decode)utf8(s,n);
                        continue;
                    default:fail("invalid string escape");
                }
            } else if(c>=128) {
                unsigned n;int count;unsigned minimum;
                if(c>=0xc2&&c<=0xdf){n=c&31;count=1;minimum=128;}
                else if(c>=0xe0&&c<=0xef){n=c&15;count=2;minimum=2048;}
                else if(c>=0xf0&&c<=0xf4){n=c&7;count=3;minimum=65536;}
                else fail("invalid UTF-8");
                for(int i=0;i<count;++i){int next=get();if((next&0xc0)!=0x80)fail("invalid UTF-8 continuation");n=(n<<6)|(next&63);}
                if(n<minimum||n>0x10ffff||(n>=0xd800&&n<=0xdfff))fail("invalid UTF-8 code point");
                if(decode)utf8(s,n);
                continue;
            }
            if(decode)s+=char(c);
        }
        return s;
    }
    void event(const char *kind, const std::string &raw="null") {
        if(mode=="basic_parse")std::cout<<"[\""<<kind<<"\","<<raw<<"]\n";
    }
    void value(const std::string &path, bool child=false, const std::string &key="") {
        ws(); std::string selected;
        bool emit=!capture && ((mode=="items" && path==prefix)||(mode=="kvitems" && child));
        if(emit)capture=&selected;
        body(path);
        if(emit) {
            capture=nullptr;
            if(mode=="kvitems")std::cout<<'['<<key<<','<<selected<<"]\n";
            else std::cout<<selected<<'\n';
            // items() callers may intentionally request just one early subtree.
            // Publish its newline before reading the rest of a large document.
            if(mode=="items")std::cout.flush();
            if(!std::cout)fail("output write error");
        }
    }
    void body(const std::string &path) {
        int c=peek();
        if(c=='{' || c=='[') {
            bool object=c=='{';get();event(object?"start_map":"start_array");ws();
            char end=object?'}':']';
            if(peek()!=end)while(true) {
                if(object) {
                    if(peek()!='"')fail("object key required");
                    // Keys must be decoded for dotted-prefix matching, and retained
                    // as raw JSON for kvitems without re-encoding numbers or strings.
                    std::string raw;auto old=capture;
                    if(!capture)capture=&raw;
                    size_t start=capture->size();std::string key=string(true);
                    std::string keyraw=capture->substr(start);capture=old;
                    event("map_key",keyraw);ws();take(':');
                    value(path.empty()?key:path+"."+key, path==prefix, keyraw);
                } else value(path.empty()?"item":path+".item");
                ws();if(peek()==end)break;take(',');ws();
            }
            take(end);event(object?"end_map":"end_array");return;
        }
        if(c=='"') {
            if(mode=="basic_parse") {std::string raw;capture=&raw;string(false);capture=nullptr;event("string",raw);}
            else string(false);
            return;
        }
        if(c=='t'||c=='f'||c=='n') {
            const char *literal=c=='t'?"true":c=='f'?"false":"null";
            for(const char *p=literal;*p;++p)take(*p);
            event(c=='n'?"null":"boolean",literal);return;
        }
        std::string raw;auto old=capture;
        if(mode=="basic_parse")capture=&raw;
        if(peek()=='-')get();
        if(peek()=='0')get();else {if(peek()<'1'||peek()>'9')fail("number or value required");while(digit(peek()))get();}
        if(peek()=='.'){get();if(!digit(peek()))fail("fraction requires digits");while(digit(peek()))get();}
        if(peek()=='e'||peek()=='E'){get();if(peek()=='+'||peek()=='-')get();if(!digit(peek()))fail("exponent requires digits");while(digit(peek()))get();}
        capture=old;event("number",raw);
    }
public:
    Parser(std::string m,std::string p):prefix(p),mode(m){}
    void run() {value("");ws();if(peek()!=EOF)fail("trailing JSON data");std::cout.flush();if(!std::cout)fail("output write error");}
};
int main(int argc,char **argv) {
    try {
        if(argc!=3)throw std::runtime_error("mode and prefix required");
        std::string mode=argv[1];
        if(mode!="items"&&mode!="kvitems"&&mode!="basic_parse")throw std::runtime_error("unknown mode");
        Parser(mode,argv[2]).run();return 0;
    } catch(const std::exception &e) {std::cerr<<e.what()<<'\n';return 1;}
}
