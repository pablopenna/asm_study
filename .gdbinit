# gdb settings for this repo -- the replacement for cppdbg's `setupCommands`,
# which Zed's GDB adapter has no equivalent for.
#
# This file is NOT auto-loaded: gdb only auto-loads a local .gdbinit from the
# *current* directory, and debug sessions here run with cwd set to the source
# subdirectory (e.g. x86/print_hex_v2), not the repo root. Source it from your
# global gdbinit instead -- see README.

# Match the nasm source.
set disassembly-flavor intel

# Auto-dump the top of the stack on every stop, the way the VS Code configs did
# via `display/8gx $rsp` / `display/8wx $esp`. `$sp` and the `a` (address)
# format are pointer-width aware, so one line covers both elf32 and elf64.
display/8a $sp

# These programs enter at _start and exit via the exit syscall; there is no
# inferior shell to clean up and no reason to prompt on quit.
set confirm off
