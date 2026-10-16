/* Congruent dirty lines force cache eviction; verify all values after refill. */
.option norvc
.option norelax
.section .text
.globl _start
_start:
    li      t5, 0x40600000
    la      t0, fail
    csrw    mtvec, t0
    li      s0, 0x80000000
    li      s1, 0x100000
    li      s2, 1
    li      s3, 65
write_loop:
    sd      s2, 0(s0)
    add     s0, s0, s1
    addi    s2, s2, 1
    bne     s2, s3, write_loop
    fence   rw, rw
    li      s0, 0x80000000
    li      s2, 1
read_loop:
    ld      t0, 0(s0)
    bne     t0, s2, fail
    add     s0, s0, s1
    addi    s2, s2, 1
    bne     s2, s3, read_loop
    fence   rw, rw
    li      t6, 1
    sd      t6, 0(t5)
done:
    j       done
fail:
    li      t6, 2
    sd      t6, 0(t5)
    j       done
