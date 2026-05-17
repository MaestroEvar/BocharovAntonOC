#include <stdio.h>
#include "../include/integral_calc.h"

int main() {
    int steps = 1000000;
    double result = integrate(0.0, 1.0, steps);
    printf("[Modular] Integral result: %f\n", result);
    return 0;
}