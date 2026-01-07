hello_world_x86.o: hello_world_x86.s
	nasm -f elf64 -o hello_world_x86.o hello_world_x86.s

hello_world_x86: hello_world_x86.o
	x86_64-linux-gnu-ld -o hello_world_x86 hello_world_x86.o

run: hello_world_x86
	qemu-x86_64 hello_world_x86

clean:
	rm *.o hello_world_x86

