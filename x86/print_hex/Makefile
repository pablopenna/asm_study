all: main

main.o: main.s
	nasm -f elf64 -o main.o main.s

main: main.o
	ld -o main.exe main.o

run: main
	./main.exe

clean:
	rm *.o *.exe

