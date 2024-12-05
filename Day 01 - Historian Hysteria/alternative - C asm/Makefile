# Add additional compiler flags here
CC=gcc

CFLAGS=-O0 -Wall -Wextra

all: day01
day01: main.c asm.S
	$(CC) $(CFLAGS) -o $@ $^
clean:
	rm -f day01