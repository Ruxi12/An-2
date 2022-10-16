#include<stdio.h>
#include <fcntl.h>
#include <unistd.h>

int main(int argc, char *argv[]){
    if(argc != 3){
        printf("no no");
    }
    int readed_file = open(argv[1], O_RDONLY);
    int write_to_file = open(argv[2], O_CREAT | O_WRONLY);

    char buf[1024];
    int readed_bytes = read(readed_file, buf, 1024);
    while( readed_bytes != 0){
        int writed_bytes = write(write_to_file, buf, readed_bytes);
        // while(writed_bytes != readed_bytes || writed_bytes != 0){
        //     writed_bytes = write(write_to_file, buf, readed_bytes);
        // }
        readed_bytes = read(readed_file, buf, 1024);
    }

    close(write_to_file);
    close(readed_file);
}
