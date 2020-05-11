# BOOTSECTOR MAKES
bootsector.bin: bootsector/bootsector.asm
	cd bootsector && nasm -f bin bootsector.asm -o bootsector.bin

# KERNEL MAKES
kernel.o: kernel/kernel.C
	cd kernel && x86_64-elf-gcc -ffreestanding -c kernel.c -o kernel.o

kernel-entry.o: kernel/kernel-entry.asm
	cd kernel && nasm kernel-entry.asm -f elf64 -o kernel-entry.o

# kernel-entry.o should always be the first object file in the linked command
kernel.bin: kernel-entry.o kernel.o
	cd kernel && x86_64-elf-ld -o kernel.bin -Ttext 0x1000 kernel-entry.o kernel.o --oformat binary

os-image.bin: kernel.bin bootsector.bin
	cat bootsector/bootsector.bin kernel/kernel.bin > os-image.bin

run: os-image.bin
	qemu-system-x86_64 os-image.bin

clean:
	rm *.o *.bin