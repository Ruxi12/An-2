#include <stdio.h>
#include <fcntl.h>
#include <errno.h>
#include <unistd.h>

int main(int argc, char* argv[]) {
    char buf[4096];
    size_t read_size;
    // open the file specified in the pathname
    // acces mode = O_RDONLY - opened for reading
    int fd1 = open(argv[1], O_RDONLY); // return file descriptor
    // check if opened correctly, with no error
   
    if (fd1 < 0){
        perror("Could not open first file\n");
        return errno;
    }
    // 0666 octal
    // i.e. every one of the 6's corresponds to three permission bits
    // -rw-rw-rw-
    // all users have read write permissions
    int fd2 = open (argv[2], O_WRONLY | O_CREAT, 0666);
    if (fd2 < 0){
        perror("Could not open second file\n");
        return errno;
    }
    // read file
    while (read_size = read(fd1, buf, sizeof(buf))){
        if (read_size < 0){
            perror("Read failed\n");
            return errno;
        }
        if (write(fd2, buf, read_size) < 0){
            perror("Write failed\n");
            return errno;
        }
    }
    // verify if files are closed
    if (close(fd1) < 0){
        perror("Close first file failed\n");
        return errno;
    }
    if (close(fd2) < 0){
        perror("Close second file failed \n");
        return errno;
    }
    return 0;
}
