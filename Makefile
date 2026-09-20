CC = gcc
CFLAGS = -std=c99 -D_POSIX_C_SOURCE=200809L -Wall -Wextra -pedantic

all: samelink

samelink: src/main.c src/slink.c src/slink.h
	$(CC) $(CFLAGS) -o samelink src/main.c src/slink.c

clean:
	rm -f samelink

test: samelink
	sh tests/run.sh

.PHONY: all clean test
