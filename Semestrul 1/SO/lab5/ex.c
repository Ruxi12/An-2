#include <sys/wait.h>
#include <stdio.h>
#include <errno.h>
#include <unistd.h>
#include <sys/wait.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/mman.h>
#define dimm 4096

int main(int argc,char* argv[]){

    int shm_fd;
    char *shm_name = "collatz";
    // O_RDWR = scriere si citire
    // S_IRUSR = 00400 user has read permission
    // S_IWUSR = 00200 user has write permission
    //  oferind drepturi asupra lui doar utilizatorului
    //care l-a creat (S IRUSR | S IWUSR)

    shm_fd = shm_open(shm_name, O_CREAT | O_RDWR, S_IRUSR | S_IWUSR);

    if(shm_fd == -1){
        perror ("ERROR - shm_open\n");
        return errno;
    }
    int dim = getpagesize();
    int shm_size = argc * dim;
    // define size
    int ftrunc = ftruncate(shm_fd, shm_size);
    if(ftrunc == -1){
        perror("ERROR - ftruncate\n");
        //sterge obiectele create cu funct, ia shm open
        shm_unlink(shm_name);
        return errno;
    }

    printf("Starting parent: %d\n", getpid());
    for(int i = 1; i < argc; ++i){
        pid_t pid = fork();
        if(pid < 0){
            perror("ERROR - Fork\n");
            return errno;
        } else
            if(pid == 0){
            // memoria partajata se incarca in spatiul procesului cu mmap
            // NULL - lasam kernelul sa decida unde incarca
            // PROT - drepturile de acces
            // map_shared - modificarile facute de proces sa fie vizibile si in celelalte
            // shm_fd - descriptorul obiectului din memorie
            //    locul in obiectul de memorie partajata de la care sa fie ıncarcat
                // ˆın spatiul procesului,
            char * shm_ptr = mmap(NULL,dim, PROT_WRITE, MAP_SHARED, shm_fd, (i - 1) * dim);

            if(shm_ptr == MAP_FAILED){
                perror("Problem with memory map in child process\n");
                shm_unlink(shm_name);
                return errno;
            }

            int argument = atoi(argv[i]);
            shm_ptr += sprintf(shm_ptr, "%d: ", argument);
            shm_ptr += sprintf(shm_ptr,"%d ", argument);
            while(argument > 1){
                if(argument & 1){ // verificam paritatea
                    argument = 3 * argument + 1;
                } else{
                    argument = argument / 2;
                }
                shm_ptr += sprintf(shm_ptr, "%d ", argument);
            }
            shm_ptr += sprintf(shm_ptr,"\n");
            printf("Done parent %d, Me %d\n", getppid(), getpid());
            // eliberare spatiu
            munmap(shm_ptr, dim);
            exit(0);
        }
    }
    //
    for(int i = 1; i < argc; ++i){
        wait(NULL);
    }

    for(int i = 1; i < argc; ++i){
        char* shm_ptr = mmap(NULL, dim, PROT_READ, MAP_SHARED, shm_fd, (i-1) * dim);
        if(shm_ptr == MAP_FAILED){
            perror("Problem with memory map in parent process\n");
            shm_unlink(shm_name);
            return errno;
        }
        printf("%s", shm_ptr);
        munmap(shm_ptr, dim);
    }
    printf("Done Parent %d Me %d\n", getppid(), getpid());
    shm_unlink(shm_name);
    return 0;
}
