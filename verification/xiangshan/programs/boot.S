.option norvc
.option norelax
.section .boot,"ax"
.globl _reset
_reset:
    la      t0, _start
    jr      t0
