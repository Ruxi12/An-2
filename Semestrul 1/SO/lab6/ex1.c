#include <stdio.h>
#include <pthread.h>
#include <errno.h>
#include <stdlib.h>
void* thread_routine(void* args){
    int len = 0;
    char *argument = (char*) args;
    // get the len of input
    while (argument[len] != '\0')
        len++;
    int resultLen = 0;
    // alloc space for the result string
    char* result = (char*) malloc (len * sizeof (char));
    // reverse
    for (int i = len - 1 ; i>=0; i--){
        result[resultLen] = argument[i];
        resultLen++;
    }
    return result;
}
int main(int argc, char* argv[]) {
    pthread_t thread;
    char* argument = argv[1];
    void* result; // pointer not associated with any data type
    // lansare fir de executie
    if (pthread_create(&thread, NULL, thread_routine, argument)){
        perror("Error at pthread_create \n");
        return errno;
    }
    // asteptare finalizare executie thread
    // asteapta explicit firul de executie in variabila thread
    if (pthread_join(thread, &result)){
        perror("Error at pthread_join\n");
        return errno;
    }
    char* finalResult = (char*) result;
    printf("Reversed string is : %s\n", finalResult);
    free(finalResult);

    return 0;
}
