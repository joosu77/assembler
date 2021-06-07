CC = gcc
CFLAGS = -m32 -g
ASM_FUNKID = quick.o inplace_merge.o bin_search.o

all: main test

main: main.o $(ASM_FUNKID)
	$(CC) $(CFLAGS) main.o $(ASM_FUNKID) -o main

test: ctest.o test.o
	$(CC) $(CFLAGS) ctest.o test.o -o test

main.o: main.c
	$(CC) $(CFLAGS) main.c -c -o main.o

ctest.o: test.c
	$(CC) $(CFLAGS) test.c -c -o ctest.o

test.o: test.asm
	nasm -f elf test.asm -o test.o

merge.o: merge.asm
	nasm -f elf merge.asm -o merge.o

#inplace_merge.o: inplace_merge.asm
#	nasm -f elf inplace_merge.asm -o inplace_merge.o

#quick.o: quick.asm
#	nasm -f elf quick.asm -o quick.o

$(ASM_FUNKID): %.o: %.asm
	nasm -f elf $< -o $@

clean:
	rm -rf *.o

run: main
	./main

run_test: test
	./test