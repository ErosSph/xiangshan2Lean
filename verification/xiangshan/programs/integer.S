/* Short first acceptance: arithmetic, both branch outcomes, jump and commit. */
.option norvc
.option norelax
.section .text
.globl _start
_start:
    li      t5, 0x40600000
    li      t0, 7
    addi    t1, t0, 11
    li      t2, 18
    bne     t1, t2, fail
    beq     t1, t2, matched
    j       fail
matched:
    j       pass
fail:
    li      t6, 2
    sd      t6, 0(t5)
done:
    j       done
pass:
    li      t6, 1
    sd      t6, 0(t5)
    j       done
