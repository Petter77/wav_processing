all:
	nasm -f elf32 -g -o echo echo.asm
	gcc -m32 -o main main.c echo