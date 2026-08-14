# ASM Study

## Setup VSCode

> Taken from https://github.com/newtonsart/vscode-assembly

### GDB
Install your distro gdb package:

Archlinux
```
sudo pacman -S gdb gcc binutils
```
Debian
```
sudo apt install gdb gcc binutils
```
Fedora
```
yum install gdb gcc binutils
```
### Debugger extension: C/C++ (`cppdbg`)

Install **`ms-vscode.cpptools`** — the extension named plain **"C/C++"**. Nothing else
provides the `cppdbg` debug type.

```
code --install-extension ms-vscode.cpptools
```

> ⚠️ **Install it into the profile you actually use.** VS Code extensions are per-profile,
> but they all share one folder on disk (`~/.vscode/extensions`), so a directory listing
> tells you nothing about whether *your* profile has it. If you use a profile (this repo
> is developed under an `Assembly` profile), pass it explicitly — otherwise the CLI
> silently targets the **Default** profile and you get
> `Configured debug type 'cppdbg' is not supported`:
>
> ```
> code --profile Assembly --install-extension ms-vscode.cpptools
> code --profile Assembly --list-extensions | grep cpptools   # verify
> ```
>
> Restart VS Code fully afterwards; a window reload is not enough.

> ⚠️ These look right but are **not** the debugger — having only these is the usual cause
> of the error above:
> - `ms-vscode.cpp-devtools` — companion tooling
> - `ms-vscode.cpptools-themes` — colour themes only
> - `ms-vscode.cpptools-extension-pack` — a bundle; fine, but confirm plain
>   `ms-vscode.cpptools` came with it

Verified against the adapter (`OpenDebugAD7`) driving gdb 15.1 on `x86/print_hex_v2`:

- **Registers** — the Variables panel gets a `Registers` scope, grouped into
  `CPU` (26 regs), `Segs`, `FPU`, `SSE`, `AVX` and `Other Registers`.
- **Memory view** — the adapter reports `supportsReadMemoryRequest: true`, and
  `readMemory` returns real bytes. Watch expressions carry a `memoryReference`, so
  right-clicking `$rsp` in the Watch panel → **View Binary Data** opens the native
  hex editor.
- **Disassembly** — `supportsDisassembleRequest: true` (Open Disassembly View).
  It needs a real address; a bare `$rip` expression is rejected.

#### Do not use `stopAtEntry`
`cppdbg` implements `stopAtEntry` by breaking on `main`. Every program here (including
the gcc-linked ones) starts at `_start`, not `main`, so with `stopAtEntry: true` the
program simply runs to completion and never stops. The launch configs therefore set it
to `false` — **set a breakpoint in the editor gutter instead**.

`setupCommands` is not a workaround: it runs before symbols are loaded, so
`-break-insert _start` fails the launch outright and `break _start` is silently ignored.

### Json files
You'll need to put the [.vscode](https://github.com/newtonsart/vscode-assembly/tree/master/.vscode) folder in your visual studio workspace

### How to allow breakpoints
Just follow the next steps: VS->Settings->Debug and change "debug.allowBreakpointsEverywhere" to true

### Optional
- [ASM Code Lens](https://marketplace.visualstudio.com/items?itemName=maziac.asm-code-lens) for syntax highlighting, completions and more.
- [x86 Instruction Reference](https://marketplace.visualstudio.com/items?itemName=whiteout2.x86) for useful information about x86 instructions