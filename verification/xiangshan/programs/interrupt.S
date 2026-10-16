/* External source 1 arrives while a test-device AXI read is waiting. */
.option norvc
.option norelax
.section .text
.globl _start
_start:
    li      t5, 0x40600000
    la      t0, trap
    csrw    mtvec, t0
    li      s0, 0
    li      t0, 0x3c000004
    li      t1, 1
    sw      t1, 0(t0)          /* PLIC source 1 priority. */
    li      t0, 0x3c002000
    li      t1, 2
    sw      t1, 0(t0)          /* Enable source 1 in M context 0. */
    li      t0, 0x3c200000
    sw      zero, 0(t0)        /* Threshold zero. */
    fence   iorw, iorw
    li      t0, 0x800
    csrs    mie, t0
    csrsi   mstatus, 8
    li      s1, 0x50000000
    ld      s2, 0(s1)          /* Environment deliberately delays this response. */
    li      t0, 0x12345678
    bne     s2, t0, fail
wait_irq:
    beqz    s0, wait_irq
    li      t0, 1
    bne     s0, t0, fail
    li      t6, 1
    sd      t6, 0(t5)
done:
    j       done
.balign 4
trap:
    csrr    t0, mcause
    li      t1, 0x800000000000000b
    bne     t0, t1, fail
    li      t0, 0x3c200004
    lw      t1, 0(t0)          /* Claim the actual pending source. */
    li      t2, 1
    bne     t1, t2, fail
    sw      t1, 0(t0)          /* Complete it. */
    csrw    mie, zero          /* Physical external level remains high in this test. */
    addi    s0, s0, 1
    mret
fail:
    li      t6, 2
    sd      t6, 0(t5)
    j       done
