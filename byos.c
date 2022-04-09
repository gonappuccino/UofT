#include "byos.h"
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <sys/stat.h>
#include <signal.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <fcntl.h>
#include <stdlib.h>




int interp(const struct cmd *c) {
    
    int std_dir;
    int new_dir;
    int ret_val = 0;
    //int ret_val;
    // if there is redirection : change the stdout

    if (c -> redir_stdout != NULL) {
        new_dir = open(c -> redir_stdout, O_WRONLY|O_CREAT, 0666);
        if(new_dir == -1) {
            perror("Error");
            return 1;
        }
        
        std_dir = dup(STDOUT_FILENO);
        dup2(new_dir, STDOUT_FILENO);
        close(new_dir);
    }

    //echo
    if(c -> type == 0) {
        write(STDOUT_FILENO, c -> data.echo.arg, strlen(c -> data.echo.arg));

    }

    //forx
    if(c -> type == 1) {
        char *path;
        path = c -> data.forx.pathname;
        char **argv;
        argv = c -> data.forx.argv;

        int status;
        pid_t pid = fork();
        if (pid == -1) {
            perror("The following error occur\n");
            return -1;
        } else if (pid == 0) {
            //child
            if(strchr(path, '/') == NULL || strstr(path, "./") != NULL) {
                if(execvp(path, argv) < 0) {
                    //printf("path vp ; - %s\n", path);
                    write(STDOUT_FILENO, "Error", strlen("Error"));
                    exit(127);
                }
            } else {
                if (execv(path, argv) < 0) { // The smallest i such that argv[i]==NULL marks the end. how????
                    //printf("path = %s\n", path);
                     write(STDOUT_FILENO, "Error", strlen("Error"));
                    exit(127);

            }
        }
            
            //exit(0);

        } else {
            //parents
            wait(&status);
            if(WIFEXITED(status)) {
                //If the child exits, the return value is the child’s exit status.
                ret_val = WEXITSTATUS(status);
                return ret_val;
            }
            else if (WIFSIGNALED(status)) {
                //If the child is killed by signal, the return value is 128+signal
                ret_val = 128 + WTERMSIG(status);
                return ret_val;
            }
        }

    }

    //list
    if(c -> type == 2){
        int n = c -> data.list.n;
        struct cmd *cmds = c -> data.list.cmds;


        for(int i = 0; i < n; i++) {
            //printf("type = %d\n", cmds[i].type);
            
            int ret = interp(&(cmds[i]));
            if(ret == 128 + SIGINT) {
                
                ret_val = (128 + SIGINT);
                break;
            }
        }
    }
    
    //restore std_out
    if (c -> redir_stdout != NULL) {
        //printf(" type = %d\n", c -> type);
        dup2(std_dir, 1);
        close(std_dir);
    }
    
    return ret_val;

}