#include <unistd.h>
#include <errno.h>
#include <stdio.h>
int main()
{
	if(write(1,"Hello, World!\n",14) < 0){
        perror("Write Failed\n");
        return errno;
    }
	return 0;
}
