/* M-mode ECALL, illegal instruction, trap entry, MEPC update and MRET. */
.option norvc
.option norelax
.section .text
.globl _start
_start:
    li      t5, 0x40600000
    la      t0, trap
    csrw    mtvec, t0
    li      s0, 0
    li      s1, 11
    ecall
    li      s1, 2
    .word   0x00004073
    li      t0, 2
    bne     s0, t0, fail
    li      t6, 1
    sd      t6, 0(t5)
done:
    j       done
.balign 4
trap:
    csrr    t0, mcause
    bne     t0, s1, fail
    csrr    t1, mepc
    addi    t1, t1, 4
    csrw    mepc, t1
    addi    s0, s0, 1
    mret
fail:
    li      t6, 2
    sd      t6, 0(t5)
    j       done
