/* This is not a regression test, just a small example to check if posix semaphores are working */

#include <pthread.h>
#include <semaphore.h>

sem_t mutex;

void *thread(void* arg);

void *thread(void* arg __attribute__((unused)))
{
    sem_wait(&mutex);
    sem_post(&mutex);
    return NULL;
}

int main(void)
{
    sem_init(&mutex, 0, 1);
    pthread_t t1, t2;
    pthread_create(&t1, NULL, thread, NULL);
    pthread_create(&t2, NULL, thread, NULL);
    pthread_join(t1, NULL);
    pthread_join(t2, NULL);
    sem_destroy(&mutex);
    return 0;
}
