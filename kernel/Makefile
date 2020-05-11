kernel.o: kernel.C
	x86_64-elf-gcc -ffreestanding -c kernel.c -o kernel.o

kernel: kernel.o
	x86_64-elf-ld -o kernel.bin -Ttext 0x1000 kernel.o --oformat binary

all: kernel