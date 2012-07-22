OUTPUT_FORMAT("elf32-shl", "elf32-sh", "elf32-shl")
/* XXX OUTPUT_ARCH(sh4)? */
OUTPUT_ARCH(sh)
ENTRY(_start)

/* XXX How do we prevent collisions between stack and code and/or heap?
 * Currently, our crt0.s doesn't use this value. */
PROVIDE (__stack = 0x8D000000);

/* It is conventional on dreamcast to load at 0x8C010000, which is 0x10000
 * beyond the start of RAM. */
__load_address = ORIGIN(ram) + 0x10000;

SECTIONS
{
    .init (__load_address) :
    {
        KEEP (*(.init))
    } >ram =0

    .plt :
    {
        *(.plt)
    } >ram

    .text :
    {
        *(.text .stub .text.* .gnu.linkonce.t.*)
        /* XXX What is .gnu.warning section and how does elf32.em come into
         * play? */
		/* .gnu.warning sections are handled specially by elf32.em. */
        *(.gnu.warning)
    } >ram

    .fini :
    {
        KEEP (*(.fini))
    } >ram =0

    .rodata :
    {
        *(.rodata .rodata.* .gnu.linkonce.r.*)
    } >ram

    .rodata1 :
    {
        *(.rodata1)
    } >ram

    .sdata2 :
    {
        *(.sdata2 .sdata2.* .gnu.linkonce.s2.*)
    } >ram

    .sbss2 :
    {
        *(.sbss2 .sbss2.* .gnu.linkonce.sb2.*)
    } >ram

    /* XXX Exception handling is probably buggy. */
    .eh_frame_hdr :
    {
        *(.eh_frame_hdr)
    } >ram

    .eh_frame :
    {
        KEEP (*(.eh_frame))
    } >ram

    .gcc_except_table :
    {
        *(.gcc_except_table .gcc_except_table.*)
    } >ram

    /* XXX We aren't sure what alignment we need here, if any. */
    /* Ensure the __preinit_array_start label is properly aligned.  We
       could instead move the label definition inside the section, but
       the linker would then create the section even if it turns out to
       be empty, which isn't pretty. */
    PROVIDE (__preinit_array_start = .);
    .preinit_array :
    {
        KEEP (*(.preinit_array))
    } >ram
    PROVIDE (__preinit_array_end = .);

    PROVIDE (__init_array_start = .);
    .init_array :
    {
        KEEP (*(.init_array))
    } >ram
    PROVIDE (__init_array_end = .);

    PROVIDE (__fini_array_start = .);
    .fini_array :
    {
        *(.fini_array)
    } >ram
    PROVIDE (__fini_array_end = .);

	.ctors :
	{
	/*	gcc uses crtbegin.o to find the start of the constructors, so
		we make sure it is first.  Because this is a wildcard, it
		doesn't matter if the user does not actually link against
		crtbegin.o; the linker won't look for a file to match a
		wildcard.  The wildcard also means that it doesn't matter which
		directory crtbegin.o is in.  */
		KEEP (*crtbegin.o(.ctors))
    /* We don't want to include the .ctor section from
       the crtend.o file until after the sorted ctors.
       The .ctor section from the crtend file contains the
       end of ctors marker and it must be last */
		KEEP (*(EXCLUDE_FILE (*crtend.o) .ctors))
		KEEP (*(SORT(.ctors.*)))
		KEEP (*(.ctors))
		. = ALIGN(4);   /* REQUIRED. LD is flaky without it. */
	} >ram

	.dtors :
	{
		KEEP (*crtbegin.o(.dtors))
		KEEP (*(EXCLUDE_FILE (*crtend.o) .dtors))
		KEEP (*(SORT(.dtors.*)))
		KEEP (*(.dtors))
	} >ram

    .data :
    {
        *(.data .data.* .gnu.linkonce.d.*)
        SORT(CONSTRUCTORS)
    } >ram

    .data1 :
    {
        *(.data1)
    } >ram

    /* XXX do something with .sdata section here, if desired. */
    /*
    .sdata :
    {
        *(.sdata .sdata.* .gnu.linkonce.s.*)
    }
    */

    .sbss :
    {
        PROVIDE (__sbss_start = .);
        PROVIDE (___sbss_start = .);
        *(.dynsbss)
        *(.sbss .sbss.* .gnu.linkonce.sb.*)
        *(.scommon)
        PROVIDE (__sbss_end = .);
        PROVIDE (___sbss_end = .);
    } >ram

    .bss :
    {
        __bss_start = ABSOLUTE(.);
        *(.dynbss)
        *(.bss .bss.* .gnu.linkonce.b.*)
        *(COMMON)
        /* Align here to ensure that the .bss section occupies space up to
          _end.  Align after .bss to ensure correct alignment even if the
          .bss section disappears because there are no input sections.  */
        . = ALIGN(4);
		__bss_end = ABSOLUTE(.);
    } >ram

    _end = . ;


    /* Stabs debugging sections.  */
    .stab 0 : { *(.stab) }
    .stabstr 0 : { *(.stabstr) }
    .stab.excl 0 : { *(.stab.excl) }
    .stab.exclstr 0 : { *(.stab.exclstr) }
    .stab.index 0 : { *(.stab.index) }
    .stab.indexstr 0 : { *(.stab.indexstr) }
    .comment 0 : { *(.comment) }
    /*  DWARF debug sections.
        Symbols in the DWARF debugging sections are relative to the beginning
        of the section so we begin them at 0.  */
    /* DWARF 1 */
    .debug          0 : { *(.debug) }
    .line           0 : { *(.line) }
    /* GNU DWARF 1 extensions */
    .debug_srcinfo  0 : { *(.debug_srcinfo) }
    .debug_sfnames  0 : { *(.debug_sfnames) }
    /* DWARF 1.1 and DWARF 2 */
    .debug_aranges  0 : { *(.debug_aranges) }
    .debug_pubnames 0 : { *(.debug_pubnames) }
    /* DWARF 2 */
    .debug_info     0 : { *(.debug_info .gnu.linkonce.wi.*) }
    .debug_abbrev   0 : { *(.debug_abbrev) }
    .debug_line     0 : { *(.debug_line) }
    .debug_frame    0 : { *(.debug_frame) }
    .debug_str      0 : { *(.debug_str) }
    .debug_loc      0 : { *(.debug_loc) }
    .debug_macinfo  0 : { *(.debug_macinfo) }
    /* SGI/MIPS DWARF 2 extensions */
    .debug_weaknames 0 : { *(.debug_weaknames) }
    .debug_funcnames 0 : { *(.debug_funcnames) }
    .debug_typenames 0 : { *(.debug_typenames) }
    .debug_varnames  0 : { *(.debug_varnames) }
}
