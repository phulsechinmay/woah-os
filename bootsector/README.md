### Bootsector code

The first sector of the disk at cylinder 0, head 0 and HDD 0 is the bootsector and usually contains the bootloader that the BIOS loads once it's done with setup. 

The assembly files in here output binaries which are used as raw disk-image inputs to QEMU. 