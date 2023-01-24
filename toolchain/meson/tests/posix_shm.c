/* This tests that /dev/shm exists and cygwin can use it for shared memory */

#ifdef __CYGWIN__
#include <stdio.h>
#include <string.h>
#include <fcntl.h>
#include <errno.h>
#include <sys/mman.h>
#include <unistd.h>

int main(void)
{
    const int size = 4096;
    const char *name = "/msys2-test";
    const char *message = "test";
    int fd_write, fd_read;
    void *ptr_write, *ptr_read;

    shm_unlink(name);
    errno = 0;

    fd_write = shm_open(name, O_CREAT | O_RDWR, 0666);
    if (fd_write == -1)
    {
        fprintf(stderr, "%s\n", strerror(errno));
        return 1;
    }
    ftruncate(fd_write, size);
    ptr_write = mmap(0, size, PROT_WRITE, MAP_SHARED, fd_write, 0);
    sprintf(ptr_write, "%s", message);

    fd_read = shm_open(name, O_RDONLY, 0666);
    ptr_read = mmap(0, size, PROT_READ, MAP_SHARED, fd_read, 0);

    shm_unlink(name);
    return (strcmp(message, (char *)ptr_read) == 0) ? 0 : 1;
}

#else

// only in cygwin

int main(void)
{
    return 0;
}

#endif
