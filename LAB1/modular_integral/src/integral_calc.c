double f(double x) {
    return x * x;
}

double integrate(double start, double end, int steps) {
    double step_size = (end - start) / steps;
    double sum = 0.0;
    for (int i = 0; i < steps; i++) {
        double x = start + i * step_size;
        sum += f(x) * step_size;
    }
    return sum;
}