# makefile for task.asm
task: main.o input.o inRnd.o output.o distance.o
	gcc -g -o task main.o input.o inRnd.o output.o distance.o -no-pie
main.o: main.asm macros.mac
	nasm -f elf64 -g -F dwarf main.asm -l main.lst
input.o: input.asm
	nasm -f elf64 -g -F dwarf input.asm -l input.lst
inRnd.o: inRnd.asm
	nasm -f elf64 -g -F dwarf inRnd.asm -l inRnd.lst
output.o: output.asm
	nasm -f elf64 -g -F dwarf output.asm -l output.lst
distance.o: distance.asm
	nasm -f elf64 -g -F dwarf distance.asm -l distance.lst
