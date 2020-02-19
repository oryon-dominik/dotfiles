# Assembler

> How-to run assembler-code

THIS TUTORIAL IS IN NO WAY COMPLETE NOR TESTET. NO WARRANTIES

## Content

- [Preparations](#preparations)
- [Usage](#usage)

---

## Preparations

TODO: fix issues on Windows, to get examples running

You need:

- a texteditor or DE of your choice (you can use vim)
- [nasm](https://de.wikipedia.org/wiki/Netwide_Assembler) the "Netwide Assembler" is an assembler for Intel x86 & x64 architectures (nasm is either preinstalled on many systems or can be installed with your OS-package-management-system, e.g: `choco install nasm`, have it on your path too, e.g: `$env:path += ";C:\Program Files\NASM"`)

## Usage

Create your first piece of assembler code

```editor

<TODO: insert Hello World Example running in both worlds>

```

Assembling the first source-file:

```shell
Linux:
nasm -f elf HelloWorld.esm

Windows:
nasm -fwin32 HelloWorld.asm
```

Now an object-file `HelloWorld.o` (or `HelloWorld.obj` on Windows) got created, we need to create our executable with:

```shell
Linux:
ld -static -m elf_i386 -s -o HelloWorld -e start HelloWorld.o

BUG/ERROR: `undefined reference to \`WinMain\``, TODO: evaluate issue (idea: use another linker?)
On Windows we can use the gcc-compiler as linker
gcc HelloWorld.obj
```

Execute the program with:

```shell
./HelloWorld
```
