all: tower

tower: tower.o asm_io.o driver.c
        gcc -m32 -o tower tower.o driver.c asm_io.o

asm_io.o: asm_io.asm asm_io.inc
        nasm -f elf32 -d ELF_TYPE asm_io.asm

tower.o: tower.asm
        nasm -f elf32 -o tower.o tower.asm

clean:
        rm *.o tower