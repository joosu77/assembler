CC=gcc
CFLAGS=-m32 -g

all: main

main: main.o quick.o
	$(CC) $(CFLAGS) main.o quick.o -o main

main.o: main.c
	$(CC) $(CFLAGS) main.c -c -o main.o

test.o: test.asm
	nasm -f elf factorial.asm -o factorial.o

merge.o: merge.asm
	nasm -f elf merge.asm -o merge.o

quick.o: quick.asm
	nasm -f elf quick.asm -o quick.o

clean:
	rm -rf *.o

run: main
	./main
