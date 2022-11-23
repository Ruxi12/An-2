#include <stdio.h>
#include <pthread.h>
#include <errno.h>
#include <stdlib.h>
#include <semaphore.h>
#include <dispatch/dispatch.h>

sem_t *semaphore;
pthread_mutex_t mutex;
int nrProcesses = 6;
void barrier (){
    static int visited = 0; //only accessible within that file
    pthread_mutex_lock(&mutex);
    if (++visited == nrProcesses){
        pthread_mutex_unlock(&mutex);
        // sem_post() increments (unlocks) the semaphore pointed to by semaphore
        sem_post(&semaphore);
        return ;
    }
    pthread_mutex_unlock(&mutex); // release the mutex object referenced by mutex
    //decrements (locks) the semaphore pointed to by sem.
    //       If the semaphore's value is greater than zero, then the decrement
    //       proceeds, and the function returns, immediately.  If the
    //       semaphore currently has the value zero, then the call blocks
    //       until either it becomes possible to perform the decrement
    sem_wait(&semaphore);
    visited--;
    sem_post(&semaphore);
}
void* thread_routine (void* arg){
    int* threadID = (int*) arg;
    printf ("%d reached the barrier\n", *threadID);
    barrier();
    printf("%d passed the barrier\n", *threadID);
    return NULL;
}
int main(){
    //initializes the unnamed semaphore at the address
    //pointed to by semaphore.
    // pshared = 0 -> semaphore is shared between the threads of a process
    // pshared != 0 => semaphore is shared between processes
    // semaphore_value = initial value for the semaphore

//    if (sem_init (&semaphore, 0, 0)){
//        perror("Error at sem_init\n");
//        return errno;
//    }
    if ((semaphore = sem_open("/semaphore", O_CREAT, 0644, 1)) == SEM_FAILED){
        perror("Error at semaphore_open\n");
        return errno;
    }
    if (pthread_mutex_init(&mutex, NULL)){
        perror("Error at pthread_mutex_init\n");
        return errno;
    }
    pthread_t* threads = malloc(sizeof (pthread_t) * nrProcesses);
    int i;
    for (i=0; i<nrProcesses; i++){
        int* argument = malloc(sizeof (int));
        *argument = i;
        pthread_create(&threads[i], NULL, thread_routine, argument );
    }
    for (i=0; i<nrProcesses; i++)
        pthread_join(threads[i], NULL);
    free(threads);
    return 0;
}
