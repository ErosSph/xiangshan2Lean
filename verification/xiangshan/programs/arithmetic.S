/* RV64 integer multiplication/division edge cases and actual 16-bit instructions. */
.option norvc
.option norelax
.section .text
.globl _start
.macro check reg, expected
    li      t6, \expected
    bne     \reg, t6, fail
.endm
_start:
    li      t5, 0x40600000
    li      t0, -25
    li      t1, 7
    mul     t2, t0, t1
    check   t2, -175
    div     t2, t0, t1
    check   t2, -3
    rem     t2, t0, t1
    check   t2, -4
    li      t0, 25
    divu    t2, t0, t1
    check   t2, 3
    remu    t2, t0, t1
    check   t2, 4
    li      t0, -1
    li      t1, 2
    mulh    t2, t0, t1
    check   t2, -1
    mulhu   t2, t0, t1
    check   t2, 1
    mulhsu  t2, t0, t1
    check   t2, -1
    li      t0, -25
    div     t2, t0, zero
    check   t2, -1
    rem     t2, t0, zero
    check   t2, -25
    li      t0, 0x8000000000000000
    li      t1, -1
    div     t2, t0, t1
    check   t2, 0x8000000000000000
    rem     t2, t0, t1
    check   t2, 0
    li      t0, 0x80000000
    divw    t2, t0, t1
    check   t2, 0xffffffff80000000
    remw    t2, t0, t1
    check   t2, 0
    li      t0, 0x7fffffff
    li      t1, 2
    mulw    t2, t0, t1
    check   t2, -2
    li      t0, 1
    li      t1, 65
    sll     t2, t0, t1
    check   t2, 2
    li      t0, -8
    sra     t2, t0, t1
    check   t2, -4
    slt     t2, t0, zero
    check   t2, 1
    sltu    t2, t0, zero
    check   t2, 0
.option rvc
    c.li    s0, 7
    c.addi  s0, -2
    c.slli  s0, 3
    c.li    s1, 2
    c.add   s0, s1
    c.mv    a0, s0
    c.beqz  s1, fail
    c.bnez  s1, compressed_taken
    c.j     fail
compressed_taken:
.option norvc
    check   a0, 42
    li      t6, 1
    sd      t6, 0(t5)
done:
    j       done
fail:
    li      t6, 2
    sd      t6, 0(t5)
    j       done
