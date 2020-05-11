make all -C bootsector
make all -C kernel
cat bootsector/bootsector.bin kernel/kernel.bin > os-image