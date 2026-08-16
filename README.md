# ASM Study

Two editor setups are checked in and they are independent — use either.

| | VS Code | Zed |
|---|---|---|
| config | `.vscode/` | `.zed/` |
| build | `tasks.json` | `tasks.json` |
| debug | `launch.json` (`cppdbg`) | `debug.json` (gdb's own DAP server) |
| extension needed | `ms-vscode.cpptools` | none for debugging |

- [Setup VS Code](#setup-vscode)
- [Setup Zed](#setup-zed)

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

---

## Setup Zed

The `.zed/` folder is checked in and needs no extension for debugging — Zed talks
to **gdb's own built-in DAP server**, so the whole `ms-vscode.cpptools` story above
does not apply.

### Toolchain

Same as the VS Code setup, plus a version floor:

```
sudo pacman -S gdb gcc binutils nasm     # or apt / yum
```

**gdb must be ≥ 14.1** — that is when gdb gained the `dap` interpreter Zed drives.
Check with `gdb --version`; on 13.x the debug configs will fail to start.

If gdb is not on `PATH`, point Zed at it in `.zed/settings.json`:

```json
"dap": { "GDB": { "binary": "/usr/bin/gdb" } }
```

### ⚠️ You need a unix shell in the worktree

This is the one real blocker, and it is not a config problem. The build tasks run
`nasm`/`ld`/`as`/`gcc` through a POSIX shell, and the debug configs need a Linux
gdb. Zed has **no Remote-WSL equivalent** to VS Code's — its remoting is
SSH-based. So on Windows, either:

- **run Zed inside WSL over SSH** (`ssh` server in the distro, then Zed →
  *Open Remote Project*), or
- run Zed natively on Linux.

Opening `D:\...\asm_study` in a native Windows Zed will give you working editing
and syntax highlighting, but every task and debug config will fail — Zed's
`"shell": "system"` is PowerShell there, and there is no `nasm`/`ld`/`gdb` to call.

### gdb settings (`setupCommands` replacement)

Zed's GDB adapter has no `setupCommands`. The equivalent gdb settings — intel
disassembly flavour, auto-dumping the top of the stack on every stop — live in
[`.gdbinit`](.gdbinit) at the repo root.

gdb will **not** pick it up on its own: local `.gdbinit` auto-load only applies to
the current directory, and these sessions run with cwd set to the source
subdirectory (`x86/print_hex_v2`, …), not the repo root. Source it once from your
global gdbinit:

```sh
mkdir -p ~/.config/gdb
echo "source /path/to/asm_study/.gdbinit" >> ~/.config/gdb/gdbinit
```

### Build

`.zed/tasks.json` mirrors the VS Code tasks one-for-one — `asm32`, `asm64`,
`gas`, `asm64+gcc`, `asm32+gcc` — with the same behaviour: assemble *every* file
sharing the active file's extension in the active file's directory, then link
them into `<activefile>.exe`. Plus a `run (active file's .exe)` task.

`cmd-shift-p` → **task: spawn**, or bind a key to rerun the last one.

`${file##*.}`/`${fileBasenameNoExtension}` became `${ZED_FILENAME##*.}`/`$ZED_STEM`,
and `cd "${fileDirname}"` became the task's `"cwd": "$ZED_DIRNAME"`.

### Debug

`.zed/debug.json` provides four configs, each wired to the matching build task via
`"build"` (Zed's `preLaunchTask`):

| config | builds with |
|---|---|
| `GDB64 (nasm elf64 + ld)` | `asm64` |
| `GDB32 (nasm elf32 + ld)` | `asm32` |
| `GDB64 (nasm elf64 + gcc)` | `asm64+gcc` |
| `GDB32 (nasm elf32 + gcc)` | `asm32+gcc` |

Open the `.asm` file you want to run, then `cmd-shift-p` → **debug: start** and
pick a config — `$ZED_DIRNAME`/`$ZED_STEM` resolve against the active editor, so
the same four configs cover every subdirectory.

#### `stopOnEntry` works here
Unlike `cppdbg` — which implemented `stopAtEntry` by breaking on `main` and so
ran these `_start`-based programs straight to completion — gdb's DAP stops at the
real entry point. The configs set `"stopOnEntry": true`, so you land on `_start`.
Gutter breakpoints work regardless; Zed has no "allow breakpoints everywhere"
gate to flip.

#### What you get vs cppdbg
- **Registers** — Zed's variable list shows a Registers scope from gdb.
- **Disassembly / memory** — driven by gdb's DAP; feature coverage here is
  thinner than `cppdbg` + `OpenDebugAD7`. When something is missing, the debug
  console is a real gdb console: `x/8gx $rsp`, `info registers`, `layout asm`
  equivalents all work by typing the command.

### Syntax highlighting

Zed has no built-in NASM grammar. Install the **Assembly** extension
(`cmd-shift-p` → *zed: extensions* → search "assembly"). `.zed/settings.json`
already maps `.asm`/`.inc`/`.s`/`.S` to the `Assembly` language and disables
format-on-save so the hand-aligned columns in these sources survive.