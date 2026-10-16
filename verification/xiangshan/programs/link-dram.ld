OUTPUT_ARCH(riscv)
ENTRY(_reset)
PHDRS { rom PT_LOAD FLAGS(5); ram PT_LOAD FLAGS(7); }
SECTIONS {
  . = 0x10000000;
  .boot : { *(.boot) } :rom
  . = 0x84000000;
  .text : { *(.text*) } :ram
  .rodata : { *(.rodata*) } :ram
  .data : { *(.data*) } :ram
  .bss : { *(.bss*) *(COMMON) } :ram
}
