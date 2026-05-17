#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>
#include <sys/wait.h>
#include <semaphore.h>
#include "../include/integral_calc.h"

typedef struct {
    double total_sum;
    sem_t semaphore;
} shared_data_t;

int main() {
    int steps = 1000000;

    shared_data_t *shared = mmap(NULL, sizeof(shared_data_t), 
                                 PROT_READ | PROT_WRITE, 
                                 MAP_SHARED | MAP_ANONYMOUS, -1, 0);
    if (shared == MAP_FAILED) {
        perror("mmap failed");
        return 1;
    }

    shared->total_sum = 0.0;
    sem_init(&shared->semaphore, 1, 1);

    pid_t pid = fork();

    if (pid < 0) {
        perror("fork failed");
        return 1;
    }

    if (pid == 0) {
        double local_sum = integrate(0.0, 0.5, steps / 2);
        printf("[Child] Result part 1: %f\n", local_sum);

        sem_wait(&shared->semaphore);
        shared->total_sum += local_sum;
        sem_post(&shared->semaphore);
        
        exit(0);
    } else {
        double local_sum = integrate(0.5, 1.0, steps / 2);
        printf("[Parent] Result part 2: %f\n", local_sum);

        sem_wait(&shared->semaphore);
        shared->total_sum += local_sum;
        sem_post(&shared->semaphore);

        wait(NULL);

        printf("[FINAL] Parallel Integral Result: %f\n", shared->total_sum);

        sem_destroy(&shared->semaphore);
        munmap(shared, sizeof(shared_data_t));
    }
    
    return 0;
}