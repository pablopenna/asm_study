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
### [GDB Debug](https://marketplace.visualstudio.com/items?itemName=DamianKoper.gdb-debug&ssr=false#qna) Extension
Press ``ctrl + p`` inside of visual studio code and paste the following command:
```
ext install DamianKoper.gdb-debug
```
### Json files
You'll need to put the [.vscode](https://github.com/newtonsart/vscode-assembly/tree/master/.vscode) folder in your visual studio workspace

### How to allow breakpoints
Just follow the next steps: VS->Settings->Debug and change "debug.allowBreakpointsEverywhere" to true

### Optional
- [ASM Code Lens](https://marketplace.visualstudio.com/items?itemName=maziac.asm-code-lens) for syntax highlighting, completions and more.
- [x86 Instruction Reference](https://marketplace.visualstudio.com/items?itemName=whiteout2.x86) for useful information about x86 instructions