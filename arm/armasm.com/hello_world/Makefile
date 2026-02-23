obj:
	arm-linux-gnueabi-as -g -o obj.o code.s

exe: obj
	arm-linux-gnueabi-ld -o exe obj.o

run: exe
	./exe

clean:
	rm -f obj.o exe
