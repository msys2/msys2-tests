/* This tests that /dev/shm exists and cygwin can use it for shared semaphores */

#ifdef __CYGWIN__

#include <fcntl.h>
#include <semaphore.h>
#include <errno.h>
#include <string.h>
#include <stdio.h>

int main(void)
{
    char * name = "/msys2-tests";
    sem_t * sema;

    sem_unlink(name);
    errno = 0;
    sema = sem_open(name, O_CREAT, 0666, 2);
    if (sema == SEM_FAILED) {
        fprintf(stderr, "%s\n", strerror(errno));
        return 1;
    }
    if (sem_wait(sema) != 0) {
        return 1;
    }
    if (sem_post(sema) != 0) {
        return 1;
    }
    if (sem_close(sema) != 0) {
        return 1;
    }
    if (sem_unlink(name) != 0) {
        return 1;
    }
    return 0;
}

#else

// while this links with winpthreads, it's not implemented there

int main(void)
{
    return 0;
}

#endif
