/* Fixed-configuration bring-up: arithmetic, taken branch, jump, load/store. */
.option norvc
.option norelax
.section .text
.globl _start
_start:
    li      t5, 0x40600000
    la      t0, trap
    csrw    mtvec, t0
    li      t0, 7
    li      t1, 11
    add     t2, t0, t1
    li      t3, 18
    bne     t2, t3, fail
    li      t0, 3
loop:
    addi    t0, t0, -1
    bnez    t0, loop
    j       memory
    j       fail
memory:
    li      s0, 0x80001000
    ld      s2, 64(s0)
    bnez    s2, fail
    sd      t2, 0(s0)
    ld      s1, 0(s0)
    bne     s1, t3, fail
    fence   rw, rw
    li      t6, 1
    sd      t6, 0(t5)
    fence   rw, rw
done:
    j       done
fail:
    li      t6, 2
    sd      t6, 0(t5)
    j       done
.balign 4
trap:
    csrr    t6, mcause
    addi    t6, t6, 16
    sd      t6, 0(t5)
    j       done
