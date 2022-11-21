#include <stdio.h>
#include <unistd.h>
#include <errno.h>
#include <stdlib.h>
void collatz(int argument){
    printf("%d : %d ", argument, argument);
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
    printf("Starting parent : %d\n", getppid());
    int i ;
    for (i=1; i<argc; i++){
        pid_t pid = fork();
        if (pid < 0){
            perror("Error at fork\n");
            return errno;
        }
        else
            if (pid == 0){
                printf ("child id = %d\n", getpid());
                int arg = atoi(argv[i]);
                printf("For number %d \n", arg);
                collatz(arg);
                exit(0);
            }
            else {
                wait(NULL);
                printf("Child %d finished\n", pid);
                printf("From parent, parent id = %d, child id = %d\n", getpid(), pid);
            }
    }


    return 0;
}
