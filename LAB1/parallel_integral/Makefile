CC = gcc
CFLAGS = -Wall -I./include -pthread

all: parallel_integral

parallel_integral: src/parallel_main.o src/integral_calc.o
	$(CC) $(CFLAGS) -o parallel_integral src/parallel_main.o src/integral_calc.o

src/parallel_main.o: src/parallel_main.c include/integral_calc.h
	$(CC) $(CFLAGS) -c src/parallel_main.c -o src/parallel_main.o

src/integral_calc.o: src/integral_calc.c include/integral_calc.h
	$(CC) $(CFLAGS) -c src/integral_calc.c -o src/integral_calc.o

clean:
	rm -f src/*.o parallel_integral