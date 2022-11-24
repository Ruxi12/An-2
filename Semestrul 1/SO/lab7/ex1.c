#include <stdio.h>
#include <pthread.h>
#include <mm_malloc.h>
#include <errno.h>
#define max_resources 10
int resources = max_resources;

pthread_mutex_t mutex;
pthread_t *threads;
int descrease_count(int count){
    // cand un mutex este inchis inseamn ca un thread detine dreptul exclusiv de executie
    // asupra zone critice
    pthread_mutex_lock(&mutex);
    // lock nu se opreste din executat pana obtine mutex-ul
    if (resources >= count){
        resources -= count;
        printf("Got  : %d, Remaining resources : %d\n", count, resources);
        pthread_mutex_unlock(&mutex);
    }
    else{
        printf("Not enough resources. Got : %d, Remaining Resources: %d\n", count, resources);
        pthread_mutex_unlock(&mutex);
        return -1;
    }
    return 0;
}
void increase_count(int count){
    pthread_mutex_lock(&mutex);
    resources += count;
    printf("Released : %d, Remaining resources; %d\n", count, resources);
    pthread_mutex_unlock(&mutex);
    //
    // return 0;
}

void* thread_routine(void* arg){
    int* argument = (int*) arg;
    int count = *argument;
    if(!descrease_count(count)){
        increase_count(count);
    }
    free(argument);
    return NULL;
}
int main() {
    threads = (pthread_t*) malloc(max_resources * sizeof (pthread_t));
    // initializes  mutex with the specified attributes for use
    // serializing critical resources
    // NULL all attributes are set to the default mutex attributes for the newly created mutex.
    if (pthread_mutex_init(&mutex, NULL)){
        perror("Error at pthread_mutex_init\n");
        return errno;
    }
    int i;
    int* argument;
    for (i=0; i<10; i++){
        argument = (int*) malloc(sizeof (int));
        *argument = i;
        // starts a new thread in the calling process - invokes thread_routine
        // NULL then the thread is created with default attributes
        if (pthread_create(&threads[i], NULL, thread_routine, argument)){
            perror("Error at pthread_create\n");
            return errno;
        }
    }

    for (i=0; i<10; i++){
        // asteptare finalizare thread 
        // spre deosebire de wait, asteapta in threads[i]
        if (pthread_join(threads[i], NULL)){
            perror("Error at pthread_join\n");
            return errno;
        }
    }

    if (pthread_mutex_destroy(&mutex)){
        perror("Error at pthread_destroy\n");
        return errno;
    }
    free(threads);
    return 0;
}
