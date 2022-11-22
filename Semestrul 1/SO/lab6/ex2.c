#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <pthread.h>
#include <sys/types.h>
struct thread_params{
    int line;
    int column;
};
int nrlin1, nrcol1, nrlin2, nrcol2;
int **first, **second, **result;

void* thread_routine (void* args){
    struct thread_params* index = (struct thread_params*) args;
    int line = index->line;
    int column = index->column;
    free(index);
    int* result = (int*) malloc(sizeof (int));
    int i;
    for (i=0; i<nrcol1; i++)
        (*result) += first[line][i] * second[i][column];
    return result;
}

int main(int argc, char* argv[]) {
    int i;
    printf("Pentru prima matrice\n");
    printf("Numarul de linii: \n");
    scanf("%d", &nrlin1);
    printf("Numarul de coloane: \n");
    scanf("%d", &nrcol1);
    // alocare spatiu pentru matrice
    first = (int**) malloc(sizeof(int*) * nrlin1);
    for (i = 0; i<nrlin1; i++)
        first[i] = (int*) malloc(sizeof(int)*nrcol1);
    //citire elemente prima matrice
    for (i=0; i<nrlin1; i++)
        for(int j = 0; j<nrcol1; j++)
            scanf("%d", &first[i][j]);

    printf("Pentru a doua matrice\n");
    printf("Numarul de linii: \n");
    scanf("%d", &nrlin2);
    printf("Numarul de coloane: \n");
    scanf("%d", &nrcol2);

    second = (int**) malloc(sizeof (int*) *nrlin2);
    for (i=0; i<nrlin2; i++)
        second[i] = (int*) malloc(sizeof (int) * nrcol2);
    printf("Dati elementele din a doua matrice \n");
    for (i=0; i<nrlin2; i++)
        for(int j = 0; j<nrcol2; j++)
            scanf("%d", &second[i][j]);
    if (nrcol1 != nrlin2){
        perror("Impossible\n");
        return errno;
    }
    else {
        pthread_t *threads = (pthread_t*) malloc(sizeof (pthread_t) * nrlin1 * nrcol2);
        int nr_threads = 0;
        //alloc for result
        result = (int**) malloc(sizeof (int)*nrlin1);
        for (i=0; i<nrlin1; i++)
            result[i] = (int*) malloc(sizeof (int) * nrcol2);
        for (i=0; i<nrlin1; i++)
            for (int j=0; j<nrcol2; j++){
                struct thread_params *index = (struct thread_params*) malloc(sizeof (struct thread_params));
                index->line = i;
                index->column = j;
                // the new thread will be stored in threads[nr_threads++]
                // NULL -> default atributes
                // se incepe executia de la adresa lui thread_routine
                // index este parametrul dat lui thread_routine
                if (pthread_create(&threads[nr_threads++], NULL, thread_routine, index)){
                    perror("Error at pthread_create\n");
                    return errno;
                }
            }
        nr_threads = 0;
        void* value;
        for (i=0; i<nrlin1; i++)
            for (int j=0; j<nrcol2; j++){
                if (pthread_join(threads[nr_threads++], &value)){
                    perror("Error at pthread_create \n");
                    return errno;
                }
                int* ret = (int*) value;
                result[i][j] = *ret;
                free(ret);
            }
        printf("Resultat:\n");
        for( i = 0; i < nrlin1; ++i){
            for(int j = 0; j < nrcol2; ++j)
                printf("%d ", result[i][j]);
            printf("\n");
        }
        // dezalocare
        for (i=0; i<nrlin1; i++)
            free(result[i]);
        free(result);
        free(threads);
    }
    for (i=0; i<nrlin1; i++)
        free(first[i]);
    free(first);
    for (i=0; i<nrlin2; i++)
        free(second[i]);
    free(second);
    return 0;
}
