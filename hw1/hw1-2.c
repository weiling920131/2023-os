#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>

char* lsh_read_line(){
    char* line=(char*)malloc(sizeof(char)*1000);
    int ind = 0;
    while(1){
        char c = getchar();
        if(c==EOF||c=='\n'){
            return line;
        }
        line[ind++] = c;
    }
}

char** lsh_split_line(char* line){
    char** args = (char**) malloc(1000);
    int ind = 0;
    char* str = strtok(line, " ");
    while(str != NULL){
        args[ind++] = str;
        str = strtok(NULL, " ");
    }

    
    return args;
}

int lsh_exit() {
    printf("Process end\n");
    return 0;
}

int lsh_launch(char** args){
    pid_t pid, child_pid;
    int status;

    pid = fork();
    if (pid == 0) {
        execvp(args[0], args);
        exit(EXIT_SUCCESS);
        
    } 
    else if (pid < 0) {
        // Fork error
        perror("lsh");
    } 
    else {
        // parent
        wait(&status);
    }

    return 1;
}


int lsh_execute(char** args){
    if(args[0] == NULL) return 1;
    if(strcmp(args[0], "exit") == 0){
        return lsh_exit();
    }
    else{
        return lsh_launch(args);
    }
}

void lsh_loop(void)
{
    int status;

    do {
        printf("osh> ");
        char* line = lsh_read_line();
        char** args = lsh_split_line(line);
        status = lsh_execute(args);

    } while (status);
}

int main(int argc, char **argv)
{
    lsh_loop();
    return EXIT_SUCCESS;
}