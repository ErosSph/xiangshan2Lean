/* Private synchronous v9 replay/observation driver. No source RTL is changed. */
#define _GNU_SOURCE
#include <vpi_user.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct { int id,w,pid,depth,offset,physical; vpiHandle t,v; vpiHandle *tw,*vw; } Object;
typedef struct { int id,w; vpiHandle t,v; } Port;
typedef struct { int pid,n; vpiHandle flags[4]; Port *args; } Diagnostic;
static Object *objects;
static Port *inputs,*outputs;
static Diagnostic *diagnostics;
static int NI,NO,NS,NP,NM,ND,NT,NW,MAXWAVE,sample=0,new_step=1,cleanup=0,ticks=0,fill;
static int *edge;
static unsigned long *counts;
static char top[1024],*tagbuf,*valuebuf,*vector;
static FILE *frames;
static vpiHandle clk,valid,ready,pre,post,fault,fired,monitors,wave,obs_obj,obs_idx;
static s_vpi_vecval *fired_copy,*monitor_copy;
static s_cb_data low_cb,high_cb,read_cb;
static s_vpi_time delay={vpiSimTime,0,1,0},zero={vpiSimTime,0,0,0};

static void die(const char *why) { vpi_printf("F57_ERROR %d %s\n",sample,why); fflush(stdout); vpi_control(vpiFinish,0); }
static void *allocate(size_t n,size_t z) { void *p=calloc(n?n:1,z);if(!p){die("allocation failed");exit(1);}return p; }
static vpiHandle handle(const char *name) {
    char *path=NULL;if(asprintf(&path,"%s.%s",top,name)<0){die("handle allocation");exit(1);}
    vpiHandle h=vpi_handle_by_name(path,NULL);free(path);
    if(!h){die(name);exit(1);}return h;
}
static void known(vpiHandle h,int width,char *dst) {
    s_vpi_value v={.format=vpiBinStrVal};vpi_get_value(h,&v);
    if(!v.value.str || (int)strlen(v.value.str)!=width){die("observation width mismatch");exit(1);}
    for(int i=0;i<width;i++)if(v.value.str[i]!='0' && v.value.str[i]!='1'){die("undefined encoded physical rail");exit(1);}
    memcpy(dst,v.value.str,(size_t)width);dst[width]=0;
}
static unsigned number(vpiHandle h) {
    int w=vpi_get(vpiSize,h);s_vpi_value v={.format=vpiVectorVal};vpi_get_value(h,&v);
    if(w>32 || v.value.vector[0].bval){die("undefined or wide protocol flag");exit(1);}
    return (unsigned)v.value.vector[0].aval;
}
static void force_number(vpiHandle h,unsigned n) { s_vpi_value v={.format=vpiIntVal};v.value.integer=(PLI_INT32)n;vpi_put_value(h,&v,NULL,vpiForceFlag); }
static void force_bits(vpiHandle h,const char *bits,int w) { memcpy(tagbuf,bits,(size_t)w);tagbuf[w]=0;s_vpi_value v={.format=vpiBinStrVal};v.value.str=tagbuf;vpi_put_value(h,&v,NULL,vpiForceFlag); }
static void deposit(vpiHandle h,int w,int ones) {
    int n=(w+31)/32;s_vpi_vecval *bits=allocate((size_t)n,sizeof(*bits));
    for(int i=0;i<n;i++)bits[i].aval=ones?0xffffffffu:0;
    s_vpi_value v={.format=vpiVectorVal};v.value.vector=bits;vpi_put_value(h,&v,NULL,vpiNoDelay);free(bits);
}
static void pair(const char *kind,int phase,Object *o,int index,vpiHandle t,vpiHandle v,int activation) {
    known(t,o->w,tagbuf);known(v,o->w,valuebuf);
    if(activation)printf("A2L %d %d %lu S %d %d %s%s\n",sample,o->pid,counts[o->pid],o->id,index,tagbuf,valuebuf);
    else printf("C2L %d %d %s %d %d %s%s\n",sample,phase,kind,o->id,index,tagbuf,valuebuf);
}
static void observe_object(Object *o,int phase,int activation) {
    if(o->depth)for(int i=0;i<o->depth;i++)pair("S",phase,o,o->offset+i,o->tw[i],o->vw[i],activation);
    else pair("S",phase,o,0,o->t,o->v,activation);
}
static int bit(const s_vpi_vecval *v,int index) { if(v[index/32].bval & (1u<<(index%32))){die("undefined event rail");exit(1);}return !!(v[index/32].aval&(1u<<(index%32))); }
static void observe(int phase) {
    for(int i=0;i<NO;i++){Port *p=&outputs[i];known(p->t,p->w,tagbuf);known(p->v,p->w,valuebuf);printf("C2L %d %d O %d 0 %s%s\n",sample,phase,p->id,tagbuf,valuebuf);}
    for(int i=0;i<NS;i++)observe_object(&objects[i],phase,0);
    s_vpi_value v={.format=vpiVectorVal};vpi_get_value(monitors,&v);memcpy(monitor_copy,v.value.vector,(size_t)((2*NM+31)/32)*sizeof(*monitor_copy));
    for(int i=0;i<NM;i++)printf("C2L %d %d M %d 0 %d%d\n",sample,phase,i,bit(monitor_copy,2*i+1),bit(monitor_copy,2*i));
    for(int i=0;i<NP;i++)if(edge[i])printf("C2L %d %d E %d 0 %lu\n",sample,phase,i,counts[i]);
    if(phase==0)for(int i=0;i<ND;i++)printf("AFLAG %d %d %u%u%u%u\n",sample,i,number(diagnostics[i].flags[0]),number(diagnostics[i].flags[1]),number(diagnostics[i].flags[2]),number(diagnostics[i].flags[3]));
    fflush(stdout);
}
static void activation(void) {
    s_vpi_value v={.format=vpiVectorVal};vpi_get_value(fired,&v);memcpy(fired_copy,v.value.vector,(size_t)((NP+31)/32)*sizeof(*fired_copy));
    for(int i=0;i<NP;i++)if(bit(fired_copy,i)){if(!edge[i]){die("latch marked as edge event");return;}counts[i]++;}
    for(int i=0;i<NS;i++)if(edge[objects[i].pid] && bit(fired_copy,objects[i].pid))observe_object(&objects[i],0,1);
    for(int i=0;i<ND;i++){
        Diagnostic *d=&diagnostics[i];if(!bit(fired_copy,d->pid))continue;
        if(number(d->flags[0])==0 && number(d->flags[1])==1 && number(d->flags[2])==0 && number(d->flags[3])==0){
            printf("F57_DIAG %d %d %d %lu\n",sample,i,d->pid,counts[d->pid]);
            for(int j=0;j<d->n;j++){Port *p=&d->args[j];known(p->t,p->w,tagbuf);known(p->v,p->w,valuebuf);printf("F56_ARG %d %d %lu %d %s%s\n",sample,i,counts[d->pid],j,tagbuf,valuebuf);}
        }
    }
}
static PLI_INT32 drive_low(p_cb_data unused) {
    (void)unused;force_number(clk,0);
    if(new_step){
        if(!number(ready)){die("input accepted while not ready");return 0;}
        if(!fgets(vector,NW+3,frames)){die("missing frozen input frame");return 0;}
        if((int)strcspn(vector,"\r\n")!=NW){die("input frame width mismatch");return 0;}
        char *p=vector;
        for(int i=0;i<NI;i++){for(int j=0;j<2*inputs[i].w;j++)if(p[j]!='0'&&p[j]!='1'){die("nonbinary physical input");return 0;}force_bits(inputs[i].t,p,inputs[i].w);p+=inputs[i].w;force_bits(inputs[i].v,p,inputs[i].w);p+=inputs[i].w;}
        force_number(valid,1);new_step=0;ticks=0;printf("F47_STEP %d\n",sample);
    }else force_number(valid,0);
    vpi_register_cb(&high_cb);return 0;
}
static PLI_INT32 drive_high(p_cb_data unused) { (void)unused;force_number(clk,1);vpi_register_cb(&read_cb);return 0; }
static PLI_INT32 read_high(p_cb_data unused) {
    (void)unused;
    if(number(fault)){die("encoded controller rejected step");return 0;}
    if(cleanup){cleanup=0;sample++;if(sample==NT){printf("F57_END %d\n",sample);fflush(stdout);vpi_control(vpiFinish,0);return 0;}new_step=1;}
    else{
        if(++ticks>8*MAXWAVE+8){die("accepted controller did not converge");return 0;}
        if(number(wave))activation();
        if(number(pre))observe(0);
        if(number(post)){observe(1);cleanup=1;}
    }
    vpi_register_cb(&low_cb);return 0;
}
static PLI_INT32 start(p_cb_data unused) {
    (void)unused;s_vpi_vlog_info info;vpi_get_vlog_info(&info);const char *config=NULL;fill=-1;
    for(int i=0;i<info.argc;i++){if(!strncmp(info.argv[i],"+F57_CONFIG=",12))config=info.argv[i]+12;if(!strncmp(info.argv[i],"+FILL=",6))fill=atoi(info.argv[i]+6);}
    if(!config || fill<0 || fill>3){die("explicit replay config and initial fill required");return 0;}
    FILE *f=fopen(config,"r");if(!f){die("config open failed");return 0;}
    char magic[32],a[1024],b[1024];
    if(fscanf(f,"%31s %1023s %d %d %d %d %d %d %d %d",magic,top,&NT,&NI,&NO,&NS,&NP,&NM,&ND,&MAXWAVE)!=10 || strcmp(magic,"F57VPI1")){die("config header mismatch");return 0;}
    inputs=allocate((size_t)NI,sizeof(*inputs));outputs=allocate((size_t)NO,sizeof(*outputs));objects=allocate((size_t)NS,sizeof(*objects));diagnostics=allocate((size_t)ND,sizeof(*diagnostics));edge=allocate((size_t)NP,sizeof(*edge));counts=allocate((size_t)NP,sizeof(*counts));
    int maxw=1;
    for(int i=0;i<NI;i++){Port *p=&inputs[i];if(fscanf(f,"%d %1023s %1023s",&p->w,a,b)!=3){die("input config");return 0;}p->t=handle(a);p->v=handle(b);NW+=2*p->w;if(p->w>maxw)maxw=p->w;}
    for(int i=0;i<NO;i++){Port *p=&outputs[i];if(fscanf(f,"%d %d %1023s %1023s",&p->id,&p->w,a,b)!=4){die("output config");return 0;}p->t=handle(a);p->v=handle(b);if(p->w>maxw)maxw=p->w;}
    for(int i=0;i<NS;i++){
        Object *o=&objects[i];if(fscanf(f,"%d %d %d %d %d %d %1023s %1023s",&o->id,&o->pid,&o->w,&o->depth,&o->offset,&o->physical,a,b)!=8){die("object config");return 0;}o->t=handle(a);o->v=handle(b);if(o->w>maxw)maxw=o->w;
        if(o->depth){o->tw=allocate((size_t)o->physical,sizeof(*o->tw));o->vw=allocate((size_t)o->physical,sizeof(*o->vw));for(int j=0;j<o->physical;j++){o->tw[j]=vpi_handle_by_index(o->t,j);o->vw[j]=vpi_handle_by_index(o->v,j);if(!o->tw[j]||!o->vw[j]){die("missing physical RAM word");return 0;}}}
    }
    for(int i=0;i<NP;i++)if(fscanf(f,"%d",&edge[i])!=1){die("process config");return 0;}
    for(int i=0;i<ND;i++){
        Diagnostic *d=&diagnostics[i];if(fscanf(f,"%d %d",&d->pid,&d->n)!=2){die("diagnostic config");return 0;}
        for(int j=0;j<4;j++){if(fscanf(f,"%1023s",a)!=1){die("flag config");return 0;}d->flags[j]=handle(a);}
        d->args=allocate((size_t)d->n,sizeof(*d->args));for(int j=0;j<d->n;j++){Port *p=&d->args[j];if(fscanf(f,"%d %1023s %1023s",&p->w,a,b)!=3){die("argument config");return 0;}p->t=handle(a);p->v=handle(b);if(p->w>maxw)maxw=p->w;}
    }
    fclose(f);tagbuf=allocate((size_t)maxw+1,1);valuebuf=allocate((size_t)maxw+1,1);vector=allocate((size_t)NW+3,1);fired_copy=allocate((size_t)(NP+31)/32,sizeof(*fired_copy));monitor_copy=allocate((size_t)(2*NM+31)/32,sizeof(*monitor_copy));
    char *frame_path=NULL;if(asprintf(&frame_path,"%s.frames",config)<0){die("frame path allocation");return 0;}frames=fopen(frame_path,"r");free(frame_path);if(!frames){die("frozen input frame file missing");return 0;}
    clk=handle("exec_clk");valid=handle("step_valid");ready=handle("step_ready");pre=handle("pre_valid");post=handle("post_valid");fault=handle("fault");fired=handle("fired");monitors=handle("observed_monitors");wave=handle("wave_valid");obs_obj=handle("obs_object");obs_idx=handle("obs_index");
    force_number(clk,0);force_number(valid,0);force_number(obs_obj,0);force_number(obs_idx,0);
    for(int i=0;i<NS;i++){Object *o=&objects[i];if(o->depth){for(int j=0;j<o->physical;j++){deposit(o->tw[j],o->w,j<o->depth && fill>=2);deposit(o->vw[j],o->w,j<o->depth && (fill&1));}}else{deposit(o->t,o->w,fill>=2);deposit(o->v,o->w,fill&1);}}
    low_cb=(s_cb_data){.reason=cbAfterDelay,.cb_rtn=drive_low,.time=&delay};high_cb=(s_cb_data){.reason=cbAfterDelay,.cb_rtn=drive_high,.time=&delay};read_cb=(s_cb_data){.reason=cbReadOnlySynch,.cb_rtn=read_high,.time=&zero};vpi_register_cb(&low_cb);return 0;
}
static void install(void) { static s_cb_data cb={.reason=cbStartOfSimulation,.cb_rtn=start};vpi_register_cb(&cb); }
void (*vlog_startup_routines[])(void)={install,0};
