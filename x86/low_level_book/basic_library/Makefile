all: main

main.o: main.s
	nasm -f elf64 -o main.o main.s

lib.o: lib.s
	nasm -f elf64 -o lib.o lib.s

main: main.o lib.o
	ld -o main.exe main.o lib.o

run: main
	./main.exe

clean:
	rm *.o *.exe

