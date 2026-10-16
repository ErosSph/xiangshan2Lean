/* Sv39 through MPRV: page-table walk, translated load/store and page fault. */
.option norvc
.option norelax
.section .text
.globl _start
_start:
    li      t5, 0x40600000
    la      t0, trap
    csrw    mtvec, t0
    li      a0, 0
    li      s5, 0
    li      s6, 0
    li      s0, 0x80010000
    li      s1, 0x80011000
    li      s2, 0x80012000
    li      s3, 0x80013000
    li      t0, 0x20004401
    sd      t0, 8(s0)
    li      t0, 0x20004801
    sd      t0, 0(s1)
    li      t0, 0x20004cc7
    sd      t0, 0(s2)
    li      t2, 0x12345678
    sd      t2, 0(s3)
    fence   rw, rw
    li      t0, -1
    csrw    pmpaddr0, t0
    li      t0, 15
    csrw    pmpcfg0, t0
    li      t0, 0x8000000000080010
    csrw    satp, t0
    sfence.vma
    li      t0, 0x1800
    csrc    mstatus, t0
    li      t0, 0x20800
    csrs    mstatus, t0
    li      t1, 0x40000000
    ld      s4, 0(t1)
    bne     s4, t2, fail
    addi    t3, t2, 1
    sd      t3, 0(t1)
    ld      s4, 0(t1)
    bne     s4, t3, fail
    li      s5, 13
    li      s6, 0x40001000
    ld      t0, 0(s6)
    li      t0, 1
    bne     a0, t0, fail
    li      t6, 1
    sd      t6, 0(t5)
done:
    j       done
.balign 4
trap:
    csrr    t0, mcause
    bne     t0, s5, fail
    csrr    t0, mtval
    bne     t0, s6, fail
    li      t0, 0x20000
    csrc    mstatus, t0
    csrr    t0, mepc
    addi    t0, t0, 4
    csrw    mepc, t0
    addi    a0, a0, 1
    mret
fail:
    li      t0, 0x20000
    csrc    mstatus, t0
    li      t6, 2
    sd      t6, 0(t5)
    j       done
