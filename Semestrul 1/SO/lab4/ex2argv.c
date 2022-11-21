#include <stdio.h>
#include <errno.h>
#include <unistd.h>
#include <sys/wait.h>
#include <stdlib.h>
void collatz(int argument){
    printf("%d ", argument);
    while(argument > 1){
        if(argument % 2){
            argument = 3 * argument + 1;
        } else{
            argument = argument / 2;
        }
        printf("%d ", argument);
    }
    printf("\n");
}
int main(int argc, char* argv[]) {
    if (argc < 2){
        perror("Few arguments\n");
        return  errno;
    }
    pid_t pid = fork();
    if (pid < 0){
        perror("Eroare la fork\n");
        return errno;
    }
    else
        if (pid == 0){
            printf("From child, parent id = %d, child id = %d\n", getppid(), getpid());
            int argument = atoi(argv[1]);
            collatz (argument);
        }
        else {
            wait(NULL);
            printf("Child %d finished\n", pid);
            printf("From parent, parent id = %d, child id = %d\n", getpid(), pid);
        }

    return 0;
}
