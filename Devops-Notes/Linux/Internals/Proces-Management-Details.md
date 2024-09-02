
### 1. **Process States**:
Linux mein ek process ke multiple states ho sakte hain. Har state system ke perspective se us process ki current condition ko represent karti hai. Common process states hain:

- **Running**: Jab process CPU par actively execute ho raha hota hai. Running state mein do conditions hoti hain:
  - **Running**: Process abhi CPU par execute ho raha hai.
  - **Runnable**: Process run ke liye ready hai, lekin CPU allocate nahi hua hai.

- **Sleeping**: Process CPU par execute nahi ho raha hai, lekin kisi event (jaise I/O operation) ka wait kar raha hai.
  - **Interruptible Sleep**: Process easily signal se interrupt ho sakta hai (jaise `SIGINT`). Process jaisi hi required event aati hai, wo phir se running state mein aa jata hai.
  - **Uninterruptible Sleep**: Process ko signal interrupt nahi kar sakta. 
  - Ye usually hardware-related operations ke dauraan hota hai. Process tab tak wait karta hai jab tak operation complete nahi hota.

- **Stopped**: Process manually stop ya suspend kiya gaya hai. Ye signal `SIGSTOP` ya `SIGTSTP` se hota hai. Debugging ke waqt bhi processes ko stop kiya ja sakta hai.

- **Zombie**: Process apna execution complete kar chuka hai, lekin uske exit status ko parent process ne abhi tak read nahi kiya hai. Zombie processes system resources use nahi karte, lekin process table mein entry le kar baithe rehte hain.

### 2. **Process Creation and Termination**:

Linux mein process creation aur termination ke liye kuch key system calls use hote hain:

- **`fork()`**: Ye system call ek naya process create karta hai jo parent process ka almost exact copy hota hai. Parent process ne jo bhi memory, environment, aur file descriptors use kiye hain, wo sab child process ke paas bhi hote hain. `fork()` return value ko check karke pata kiya ja sakta hai ki abhi parent process execute ho raha hai ya child process.

  - **Parent Process**: `fork()` return karta hai child process ka PID (Process ID).
  - **Child Process**: `fork()` return karta hai 0.

- **`exec()`**: `fork()` ke baad, agar child process ko koi alag program execute karna ho, toh `exec()` family of functions (jaise `execl()`, `execp()`, etc.) use hota hai. `exec()` current process image ko naye program ke image se replace kar deta hai. `exec()` ke baad, previous process execution flow wapas nahi aata.

- **`wait()`**: Parent process `wait()` ya `waitpid()` system calls use karke apne child process ki termination ka wait kar sakta hai. Jab child process terminate hota hai, toh parent process ko child ka exit status return hota hai. Ye zaroori hai zombie processes ko clean up karne ke liye.

- **`exit()`**: Ye function process ko terminate karta hai aur OS ko ek exit status code return karta hai. Ye status parent process ko `wait()` ke through milta hai. Process ke exit hone par saare open file descriptors close ho jaate hain aur memory release ho jaati hai.

### 3. **Signals and Signal Handling**:

Signals ek asynchronous notification system hai jo ek process ko kisi event ke hone par inform karte hain. Har signal ek unique number se identify hota hai. Kuch common signals hain:

- **`SIGINT`**: Interrupt signal (usually Ctrl+C se generate hota hai). Isse process ko terminate kiya jaata hai.
- **`SIGKILL`**: Forcefully process ko terminate karne ke liye use hota hai. Process is signal ko ignore nahi kar sakta.
- **`SIGTERM`**: Gracefully process ko terminate karne ke liye. Process ko cleanup operations perform karne ka mauka milta hai.
- **`SIGHUP`**: Terminal hang-up signal. Ye daemon processes ko reload karne ke liye bhi use hota hai.

**Signal Handlers**: Signals ko handle karne ke liye processes signal handlers set kar sakte hain. Jab signal aata hai, OS process ko uske corresponding handler function mein divert karta hai. `signal()` ya `sigaction()` functions ka use karke signal handlers define kiye jaate hain.

Example of a simple signal handler:

```c
#include <stdio.h>
#include <signal.h>
#include <unistd.h>

void signal_handler(int signum) {
    printf("Received signal %d\n", signum);
}

int main() {
    signal(SIGINT, signal_handler); // Set handler for SIGINT
    while(1) {
        printf("Running...\n");
        sleep(1);
    }
    return 0;
}
```

## Details of InterProcess Communication

### 1. **Pipes (Anonymous and Named Pipes - FIFO)**

#### **Anonymous Pipes**:
- **Definition**: Anonymous pipes ek unidirectional communication channel hoti hain, jo generally parent-child processes ke beech data exchange karne ke liye use hoti hain. Ye ek hi system ke andar short-lived communication ke liye suitable hoti hain.
- **How It Works**: 
  - Pipe create karne ke liye `pipe()` system call use hota hai. Ye ek read file descriptor aur ek write file descriptor return karta hai.
  - Ek process write-end par data likhta hai, aur doosra process read-end se data read karta hai.
- **Limitation**: Ye sirf related processes (jaise parent-child) ke beech hi kaam karte hain aur unidirectional hote hain.

#### **Named Pipes (FIFOs)**:
- **Definition**: Named pipes ya FIFOs (First In, First Out) persistent hoti hain aur unka ek name hota hai, jisse multiple unrelated processes communicate kar sakte hain.
- **How It Works**: 
  - `mkfifo` command ya `mkfifo()` system call se FIFO file create hota hai.
  - Ek process FIFO file par write operation perform karta hai, aur doosra process us file se read operation.
- **Usage Example**:
  - Ek terminal mein: `echo "Hello" > mypipe`
  - Doosre terminal mein: `cat < mypipe`

### 2. **Message Queues**

- **Definition**: Message queues processes ko messages ko queues mein exchange karne ka tarika provide karti hain. Message queues zyada flexible aur complex data exchange allow karti hain, kyunki har message ek type se associated hota hai.
- **How It Works**: 
  - Message queue create aur manage karne ke liye `msgget()`, `msgsnd()`, `msgrcv()`, `msgctl()` system calls use hote hain.
  - `msgget()` se ek message queue create ya access hoti hai.
  - `msgsnd()` aur `msgrcv()` ke through messages send aur receive kiye jaate hain. Messages ko unke type ke basis par filter kiya ja sakta hai.
- **Advantages**: Message queues asynchronous communication allow karti hain, jisme messages queue mein store hote hain jab tak receiving process unhe read na kare.

### 3. **Shared Memory**

- **Definition**: Shared memory ek IPC technique hai jisme multiple processes ek shared memory segment use karte hain. Ye sabse fast IPC method hai kyunki data kisi intermediary process ya kernel space se pass nahi hota.
- **How It Works**:
  - `shmget()` system call se shared memory segment create hota hai.
  - `shmat()` se process shared memory segment ko apne address space mein attach karta hai.
  - `shmdt()` se shared memory segment detach hota hai.
  - `shmctl()` se control operations jaise segment ko remove karna perform kiya jaata hai.
- **Usage**: Shared memory ka use tab hota hai jab large amount of data ko quickly exchange karna hota hai. Synchronization ko maintain karne ke liye semaphores ka use kiya ja sakta hai.

### 4. **Semaphores**

- **Definition**: Semaphores ek synchronization mechanism hai jo processes ke beech shared resources ke access ko control karte hain. Ye counter ki tarah hota hai jo track karta hai ki kitne resources available hain.
- **Types**:
  - **Binary Semaphore**: Sirf 0 aur 1 values hold karta hai, critical sections ke liye use hota hai.
  - **Counting Semaphore**: Zyada granular control deta hai, multiple instances track karta hai.
- **How It Works**: 
  - `semget()` se semaphore set create hota hai.
  - `semop()` se semaphore operations perform hote hain (wait aur signal operations).
  - `semctl()` se semaphore set ko manage kiya jaata hai.
- **Usage Example**: File access synchronization, memory access synchronization, etc.

### 5. **Sockets**

- **Definition**: Sockets network-based IPC mechanism hai. Ye local (UNIX domain sockets) ya remote (TCP/IP) processes ke beech communication allow karte hain.
- **How It Works**:
  - **UNIX Domain Sockets**: Local system ke processes ke beech communication ke liye. Ye high-speed data exchange allow karte hain kyunki data network stack se nahi guzarta.
  - **TCP/IP Sockets**: Different systems ke processes ke beech communication ke liye, standard network protocols ka use karke. Ye internet-based communication ka base hain.
- **Common Operations**:
  - `socket()`: Ek socket create karta hai.
  - `bind()`: Socket ko ek address assign karta hai.
  - `listen()` and `accept()`: Server side par connections handle karta hai.
  - `connect()`: Client side se connection request bhejta hai.
  - `send()` and `recv()`: Data send aur receive karne ke liye.



# **Semaphores Kya Hote Hain?**

Semaphore ek counter jaisa hota hai jo track karta hai ki kitne resources available hain. 
- Iska use system mein tab hota hai jab multiple processes ek hi resource (jaise memory, printer, etc.) ko access karte hain, aur hume ensure karna hota hai ki sab kuch theek se manage ho.

### **Types of Semaphores**

1. **Binary Semaphore (Mutex)**:
   - Iska value sirf do hi states mein hota hai: 0 ya 1.
   - Binary semaphore ka use `critical section mein mutual exclusion ke liye hota hai, matlab ek samay par sirf ek hi process access kar sakta hai`.
   - Jab semaphore ka value 1 hota hai, iska matlab hai ki resource free hai. 
   - Aur jab 0 hota hai, matlab resource occupied hai.

2. **Counting Semaphore**:
   - Iska value non-negative integers hota hai, aur ye count karta hai ki kitne resources available hain.
   - Agar aapke paas ek se zyada resources hain, toh `counting semaphores ka use kiya jaata hai`. Iska value resource ki available instances ke number ko represent karta hai.

### **Operations on Semaphores**


1. **Wait Operation (P operation)**: 
   - Isko `down()` ya `acquire()` bhi kehte hain.
   - Jab koi process critical section mein enter karna chahta hai, toh ye operation perform hota hai.
   - Agar semaphore ka value greater than zero hai, toh usko ek kam kar diya jata hai aur process proceed kar sakta hai.
   - Agar value zero hai, `toh process wait karta hai jab tak value greater than zero na ho jaaye.`

2. **Signal Operation (V operation)**:
   - Isko `up()` ya `release()` bhi kehte hain.
   - Jab process apna kaam complete kar leta hai, toh ye operation perform hota hai.
   - Is `operation se semaphore ki value ek increment ho jaati hai.`
   - Agar koi process wait kar raha hai, toh usko unblocked karke proceed karne diya jata hai.

### **Semaphores Kaam Kaise Karte Hain? (Example Scenario)**


1. **Initialization**:
   - Ek semaphore `printer_semaphore` create karein jiska initial value 1 ho (kyunki sirf ek printer hai).

2. **Printer Ko Use Karna**:
   - Jab koi process printer ko use karna chahega, toh `wait` operation perform karega.
   - Agar `printer_semaphore` ki value 1 hai, toh process usko zero kar dega aur printer use karega.
   - Agar value 0 hai, toh process wait karega jab tak printer free na ho jaaye.

3. **Printer Ko Release Karna**:
   - Jab process printing complete kar lega, toh `signal` operation perform karega.
   - Isse `printer_semaphore` ki value ek se increment ho jayegi (1 ho jayegi), aur agar koi process wait kar raha hai, toh wo proceed kar payega.

### **Semaphore Implementation Linux Mein**

Linux mein semaphores ko system calls ke through manage kiya jata hai:

1. **`semget()`**: Ye system call naya semaphore set create karta hai ya existing ko access karta hai.
2. **`semop()`**: Ye operations (wait aur signal) perform karta hai.
3. **`semctl()`**: Ye semaphore set ko control karta hai (remove, status check, etc.).

### **Example: Semaphore Use Karne Ka C Code (POSIX Semaphores)**

```c
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <semaphore.h>
#include <unistd.h>

#define NUM_THREADS 5

sem_t semaphore;

void* thread_function(void* arg) {
    int thread_num = *((int*)arg);
    sem_wait(&semaphore); // Wait operation: semaphore ko acquire karo

    printf("Thread %d is in the critical section\n", thread_num);
    sleep(1); // Simulate kaam karna

    sem_post(&semaphore); // Signal operation: semaphore ko release karo
    printf("Thread %d is leaving the critical section\n", thread_num);
    return NULL;
}

int main() {
    pthread_t threads[NUM_THREADS];
    int thread_nums[NUM_THREADS];

    // Semaphore ko initialize karo with 2 (do threads ek saath access kar sakte hain)
    sem_init(&semaphore, 0, 2);

    // Threads create karo
    for (int i = 0; i < NUM_THREADS; i++) {
        thread_nums[i] = i;
        pthread_create(&threads[i], NULL, thread_function, &thread_nums[i]);
    }

    // Wait for threads to finish
    for (int i = 0; i < NUM_THREADS; i++) {
        pthread_join(threads[i], NULL);
    }

    // Semaphore ko destroy karo
    sem_destroy(&semaphore);

    return 0;
}
```

### **Explanation of the Code**:
- Is example mein semaphore 2 se initialize kiya gaya hai, matlab do threads ek hi time par critical section ko access kar sakte hain.
- `sem_wait()` function thread ko wait karne lagata hai jab tak semaphore ki value greater than zero nahi ho jaati.
- `sem_post()` function semaphore ki value ko increment karta hai aur blocked threads ko proceed karne deta hai.

### **Semaphores Ke Fayde**

1. **Mutual Exclusion**: Semaphores ensure karte hain ki ek time par sirf limited number of processes hi critical section ko access karein.
2. **Resource Management**: Counting semaphores multiple instances `wale resources ko efficiently manage karte hain.`
3. **Deadlock Prevention**: Sahi implementation ke saath semaphores deadlock se bachne mein madad karte hain.

### **Challenges and Considerations**

1. **Deadlock**: Agar semaphores ko sahi se manage nahi kiya gaya, toh deadlock ho sakta hai, jaha processes resource ke wait mein atak jaate hain.
2. **Priority Inversion**: Lower-priority process semaphore ko hold kar ke higher-priority process ko block kar sakta hai, `jo performance issues create karta hai.`
3. **Complexity**: Semaphore-based synchronization implement karna thoda complex hota hai, `especially jab large aur multi-threaded applications mein use kiya jaaye.`

