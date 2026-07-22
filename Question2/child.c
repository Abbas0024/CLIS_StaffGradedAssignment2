#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>
#include <signal.h>

int main() {
    pid_t pid = fork();

    if (pid < 0) {
        perror("fork failed");
        exit(1);
    } 
    else if (pid == 0) {
        printf("child (PID %d) handling request...\n", getpid());
        sleep(10); 
	exit(0);
    } 
    else {
        int status;
        int timeout = 3; 

        while (timeout > 0) {
            pid_t result = waitpid(pid, &status, WNOHANG);
            
            if (result == pid) {
                printf("child completed successfully within timeout.\n");
                return 0; 
            }
            sleep(1);
            timeout--;
        }

        printf("child (PID %d) unresponsive sending signalkill...\n", pid);
        kill(pid, SIGKILL); 

        waitpid(pid, &status, 0); 
        printf("unresponsive child zombie prevented.\n");
    }
    return 0;
}
