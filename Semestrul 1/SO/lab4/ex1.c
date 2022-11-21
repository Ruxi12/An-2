#include <stdio.h>
#include <unistd.h> //pid_t
#include <errno.h> // erno
#include <sys/wait.h> // wait

int main() {
    pid_t pid = fork();
    if (pid < 0){
        perror("Error ar fork\n");
        return errno;
    }
    else
        if (pid == 0) {
            printf ("From child, parent id = %d, child id = %d\n", getppid(), getpid());
            const char* path = "/bin/ls";  //path is absolute
            char *argv[] = {"ls", NULL};
            execve(path, argv, NULL); // execute program from path
            // execve se fol de obicei cu fork pentru ca procesul
            // suprascris sa fie acela nou creat
        }
        else {
            // se suspenda activitatea parintelui pentru
            // a astepta copilul
            wait(NULL);
            printf("From parent, parent id = %d, child id = %d\n", getpid(), pid);
        }
    return 0;
}
