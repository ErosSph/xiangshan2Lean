/* F/D results are moved back to integer registers for independent comparison. */
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
    li      t0, 0x6000
    csrs    mstatus, t0
    li      t0, 0x3ff8000000000000
    fmv.d.x ft0, t0             /* 1.5 */
    li      t0, 0x4000000000000000
    fmv.d.x ft1, t0             /* 2.0 */
    fadd.d  ft2, ft0, ft1
    fmv.x.d t0, ft2
    check   t0, 0x400c000000000000
    fmul.d  ft2, ft0, ft1
    fmv.x.d t0, ft2
    check   t0, 0x4008000000000000
    fdiv.d  ft2, ft1, ft1
    fmv.x.d t0, ft2
    check   t0, 0x3ff0000000000000
    li      t0, 0x4010000000000000
    fmv.d.x ft3, t0             /* 4.0 */
    fsqrt.d ft2, ft3
    fmv.x.d t0, ft2
    check   t0, 0x4000000000000000
    fmadd.d ft2, ft0, ft1, ft0
    fmv.x.d t0, ft2
    check   t0, 0x4012000000000000
    fcvt.w.d t0, ft0, rtz
    check   t0, 1
    flt.d   t0, ft0, ft1
    check   t0, 1
    fsgnjn.d ft2, ft0, ft0
    fmv.x.d t0, ft2
    check   t0, 0xbff8000000000000
    li      t0, 0x3fc00000
    fmv.w.x ft0, t0             /* NaN-boxed single-precision 1.5 */
    li      t0, 0x40000000
    fmv.w.x ft1, t0
    fadd.s  ft2, ft0, ft1
    fmv.x.w t0, ft2
    check   t0, 0x40600000
    li      t0, 0x8000000000000000
    fmv.d.x ft2, t0
    fclass.d t0, ft2
    check   t0, 8               /* Negative zero */
    fmv.d.x ft4, zero
    csrw    fflags, zero
    fdiv.d  ft2, ft4, ft4
    fmv.x.d t0, ft2
    check   t0, 0x7ff8000000000000
    csrr    t0, fflags
    check   t0, 16              /* Invalid operation */
    li      t6, 1
    sd      t6, 0(t5)
done:
    j       done
fail:
    li      t6, 2
    sd      t6, 0(t5)
    j       done
