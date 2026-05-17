CC = gcc
CFLAGS = -Wall -I./include

all: modular_integral

modular_integral: src/integral_main.o src/integral_calc.o
	$(CC) $(CFLAGS) -o modular_integral src/integral_main.o src/integral_calc.o

src/integral_main.o: src/integral_main.c include/integral_calc.h
	$(CC) $(CFLAGS) -c src/integral_main.c -o src/integral_main.o

src/integral_calc.o: src/integral_calc.c include/integral_calc.h
	$(CC) $(CFLAGS) -c src/integral_calc.c -o src/integral_calc.o

clean:
	rm -f src/*.o modular_integral