
### 1. **User Space and Kernel Space**:
   - **User Space**: Ye wo part hota hai jaha aapke applications aur commands run hote hain, jaise `ls`, `cat`, `vim`, etc. User space direct hardware se interact nahi karta, iske liye use kernel ki zaroorat hoti hai.
   - **Kernel Space**: Kernel space wo part hota hai jaha Linux kernel run karta hai. Kernel hardware resources ko manage karta hai aur user space applications ko services provide karta hai.

### 2. **Command Execution**:
   - Jab aap `ls -l` jaise command type karte ho aur Enter press karte ho, toh shell (jaise bash) is command ko interpret karta hai aur execute karta hai. Ye shell bhi ek user space application hai.

### 3. **System Call**:
   - **System Call**: Ye ek tarika hota hai jisse user space applications kernel se baat karte hain. Jab `ls -l` command execute hoti hai, toh wo kernel se file system se related information mangti hai. Ye kaam system calls ke through hota hai.
   - `ls` command file information ko retrieve karne ke liye `open()`, `read()`, aur `close()` jaise system calls ka use karti hai.

### 4. **Context Switching**:
   - Jab `ls -l` command system call karti hai, toh context switch hota hai. Matlab, execution user space se switch hokar kernel space mein chala jata hai. Iske baad, kernel system call ko handle karta hai.
   - Kernel space mein execute hone ke baad, response wapas user space application (jaise shell) ko diya jata hai. Ye process itni fast hoti hai ki user ko pata bhi nahi chalta.

### 5. **Interacting with File System**:
   - `ls -l` command file system ki directory ko read karne ke liye `readdir()` system call ka use karti hai. Kernel file system se information nikalta hai, jaise file names, permissions, size, etc., aur usse `ls` command ko return karta hai.

### 6. **Displaying Output**:
   - Jab kernel `ls -l` ko requested information return karta hai, tab `ls` us information ko format karta hai aur screen par output ke roop mein display karta hai.

### 7. **Example of System Calls Used by `ls -l`**:
   - **`open()`**: Directory ko open karne ke liye.
   - **`read()`**: Directory content ko padhne ke liye.
   - **`stat()`**: Files aur directories ke attributes jaise size, permissions ko retrieve karne ke liye.
   - **`close()`**: Directory close karne ke liye.

# SYSTEM-CALLS

### 1. **`open()` System Call**
- **Purpose**: `open()` system call ko use karke file ko access ke liye khola jata hai. File ko read ya write mode mein open kiya ja sakta hai.
- **Usage**:
  - **Syntax**: `int fd = open(const char *pathname, int flags, mode_t mode);`
  - **Parameters**:
    - `pathname`: File ka path jise open karna hai.
    - `flags`: Mode specify karta hai jaise `O_RDONLY` (read-only), `O_WRONLY` (write-only), `O_RDWR` (read and write), `O_CREAT` (nayi file create karna agar exist nahi karti), etc.
    - `mode`: Optional parameter, nayi file create hone par uska permission mode specify karta hai.
  - **Return Value**: Ye file descriptor (fd) return karta hai, jo ek unique integer hota hai, aur file ko identify karta hai. Agar open operation fail ho jaata hai, toh `-1` return hota hai.

- **Example**:
  ```c
  int fd = open("example.txt", O_RDWR | O_CREAT, 0644);
  if (fd == -1) {
      perror("open");
      exit(1);
  }
  ```

### 2. **`read()` System Call**

- **Purpose**: `read()` system call ko use karke file se data read kiya jata hai. Ye file descriptor ko use karke file se content ko buffer mein read karta hai.
- **Usage**:
  - **Syntax**: `ssize_t read(int fd, void *buf, size_t count);`
  - **Parameters**:
    - `fd`: File descriptor jo `open()` se mila hai.
    - `buf`: Buffer jisme data read kiya jayega.
    - `count`: Kitne bytes read karne hain.
  - **Return Value**: Actual bytes jo read hui hain uska number return karta hai. Agar `0` return hota hai, iska matlab end-of-file (EOF) reach ho gaya. Agar error hota hai, toh `-1` return hota hai.

- **Example**:
  ```c
  char buffer[100];
  int fd = open("example.txt", O_RDONLY);
  ssize_t bytes_read = read(fd, buffer, sizeof(buffer));
  if (bytes_read == -1) {
      perror("read");
  }
  ```

### 3. **`write()` System Call**

- **Purpose**: `write()` system call ko use karke data ko file mein likha jata hai. Ye file descriptor ke through specified buffer se data ko file mein write karta hai.
- **Usage**:
  - **Syntax**: `ssize_t write(int fd, const void *buf, size_t count);`
  - **Parameters**:
    - `fd`: File descriptor.
    - `buf`: Buffer jisme data likhne ke liye hai.
    - `count`: Kitne bytes write karne hain.
  - **Return Value**: Actual bytes jo write hui hain uska number return karta hai. Error hone par `-1` return hota hai.

- **Example**:
  ```c
  const char *text = "Hello, World!";
  int fd = open("example.txt", O_WRONLY | O_CREAT, 0644);
  ssize_t bytes_written = write(fd, text, strlen(text));
  if (bytes_written == -1) {
      perror("write");
  }
  ```

### 4. **`close()` System Call**

- **Purpose**: `close()` system call open file ko close karta hai. Ye file descriptor ko release karta hai taaki woh dobara use ho sake.
- **Usage**:
  - **Syntax**: `int close(int fd);`
  - **Parameters**:
    - `fd`: File descriptor jo close karna hai.
  - **Return Value**: Success hone par `0` return karta hai, error hone par `-1`.

- **Example**:
  ```c
  int fd = open("example.txt", O_RDONLY);
  if (fd != -1) {
      close(fd);
  }
  ```

### 5. **`fork()` System Call**

- **Purpose**: `fork()` ek process ko duplicate karta hai, aur ek naya child process create karta hai jo parent process ka almost exact copy hota hai.
- **Usage**:
  - **Syntax**: `pid_t fork();`
  - **Return Value**:
    - Parent process ko child process ka PID return karta hai.
    - Child process ko `0` return karta hai.
    - Error hone par `-1` return karta hai.

- **Example**:
  ```c
  pid_t pid = fork();
  if (pid == 0) {
      // Child process
      printf("This is the child process.\n");
  } else if (pid > 0) {
      // Parent process
      printf("This is the parent process.\n");
  } else {
      perror("fork");
  }
  ```

### 6. **`exec()` System Call**

- **Purpose**: `exec()` family of functions ek process ke current code ko nayi program ke code se replace karte hain. `fork()` ke baad typically `exec()` use hota hai.
- **Usage**:
  - Commonly used functions: `execl()`, `execp()`, `execle()`, `execvp()`, etc.
  - **Syntax**: `int execl(const char *path, const char *arg, ...);`
  - **Parameters**:
    - `path`: Naye program ka path.
    - `arg`: Arguments jo naye program ko pass karne hain.
  - **Return Value**: `exec()` call successful hone par kabhi return nahi hota. Agar error hota hai, toh `-1` return hota hai.

- **Example**:
  ```c
  execl("/bin/ls", "ls", "-l", (char *)NULL);
  perror("execl"); // Ye tabhi execute hoga agar exec fail ho gaya
  ```

### 7. **`wait()` System Call**

- **Purpose**: `wait()` system call parent process ko wait karne deta hai jab tak child process terminate nahi ho jata. Ye child ka exit status bhi return karta hai.
- **Usage**:
  - **Syntax**: `pid_t wait(int *status);`
  - **Parameters**:
    - `status`: Pointer to integer jo child process ke exit status ko store karta hai.
  - **Return Value**: Terminated child process ka PID return karta hai. Error hone par `-1`.

- **Example**:
  ```c
  pid_t pid = fork();
  if (pid == 0) {
      // Child process
      sleep(2);
  } else {
      // Parent process
      int status;
      wait(&status);
      printf("Child exited with status %d\n", WEXITSTATUS(status));
  }
  ```

### 8. **`mmap()` System Call**

- **Purpose**: `mmap()` system call file ko memory mein map karta hai. Iska use large files ko memory mein load karne ke liye hota hai jisse file access fast ho jata hai.
- **Usage**:
  - **Syntax**: `void *mmap(void *addr, size_t length, int prot, int flags, int fd, off_t offset);`
  - **Parameters**:
    - `addr`: Starting address, usually `NULL`.
    - `length`: Map area ki size.
    - `prot`: Protection options, jaise `PROT_READ`, `PROT_WRITE`.
    - `flags`: Mapping flags, jaise `MAP_SHARED`, `MAP_PRIVATE`.
    - `fd`: File descriptor jo `open()` se mila hai.
    - `offset`: File mein offset jaha se mapping start hoti hai.
  - **Return Value**: Successful mapping hone par starting address return karta hai, error hone par `MAP_FAILED`.

- **Example**:
  ```c
  int fd = open("example.txt", O_RDONLY);
  if (fd == -1) {
      perror("open");
      exit(1);
  }
  char *data = mmap(NULL, 100, PROT_READ, MAP_PRIVATE, fd, 0);
  if (data == MAP_FAILED) {
      perror("mmap");
      close(fd);
      exit(1);
  }
  printf("%s\n", data);
  munmap(data, 100);
  close(fd);
  ```

- System calls jaise `open()`, `read()`, `write()`, `close()`, `fork()`, `exec()`, `wait()`, `mmap()` directly kernel ke saath interact karte hain aur user space processes ko necessary functionalities provide karte hain. Inhe sahi tarike se samajhna aur implement karna critical hota hai robust, efficient, aur reliable systems develop karne ke liye, especially jab production environments jahan scaling aur performance
---

# **File Descriptor Kya Hota Hai?**

- **Definition**: File descriptor ek integer identifier hota hai jo operating system ke dwara kisi bhi `open file, network socket, ya device ko represent karta hai`. 
    - Jab bhi koi process file ya resource ko open karta hai, toh operating system us file/resource ke liye ek unique file descriptor assign karta hai.

- **Basic Concept**: Jab bhi koi program `open()`, `socket()`, ya koi bhi input/output operation perform karta hai, toh us operation ka result ek file descriptor hota hai. 
    - Ye file descriptor OS ko help karta hai track karne mein ki kaunsi file ya resource use ho raha hai.

### **Common File Descriptors**
1. **Standard Input (`stdin`)**:
   - File Descriptor Number: **0**
   - **Description**: By default, standard input keyboard se aata hai. Programs jo input lete hain, wo `stdin` se input read karte hain.

2. **Standard Output (`stdout`)**:
   - File Descriptor Number: **1**
   - **Description**: Ye output stream ko represent karta hai. By default, standard output screen par dikhaya jata hai.

3. **Standard Error (`stderr`)**:
   - File Descriptor Number: **2**
   - **Description**: Ye error messages ke liye hota hai. By default, errors bhi screen par dikhaye jaate hain, lekin alag stream mein taaki normal output se differentiate kiya ja sake.

### **Kaise Kaam Karta Hai File Descriptor?**

- Jab koi process ek file open karta hai, jaise `open("example.txt", O_RDWR)`, toh `open()` system call ek naya file descriptor generate karta hai (maan lijiye 3). Ye file descriptor us specific file ke liye use hoga.
- File descriptor ko aap ek reference ki tarah samajh sakte hain, jisse operating system file operations ko manage karta hai, jaise read, write, ya close.

### **File Descriptors in System Calls**

1. **`open()`**:
   - Ek file ko open karta hai aur ek file descriptor return karta hai. Example:
     ```c
     int fd = open("example.txt", O_RDONLY); // Agar successfully open hoti hai, toh fd 3 ya koi unique number hoga.
     ```

2. **`read()`**:
   - File descriptor ko use karke file se data read karta hai.
     ```c
     char buffer[100];
     read(fd, buffer, sizeof(buffer)); // fd se data read karke buffer mein store hota hai.
     ```

3. **`write()`**:
   - File descriptor ke through file mein data likhta hai.
     ```c
     write(fd, "Hello, World!", 13); // fd ke through "Hello, World!" likhta hai.
     ```

4. **`close()`**:
   - File descriptor ko release karta hai. File descriptor close hone ke baad uska use nahi kiya ja sakta bina usse dobara open kiye.
     ```c
     close(fd); // fd release karta hai.
     ```

### **Use Cases and Importance**

1. **Resource Management**: File descriptors OS ko resources track karne mein madad karte hain. Har open file, socket, ya device ka ek unique file descriptor hota hai.
2. **Security and Isolation**: Processes apne `file descriptors ke through hi resources access karte hain. Unhe directly memory address ya resource pointers access nahi milte`.
3. **Efficient Communication**: Network sockets, pipes, ya inter-process communication (IPC) ke liye file descriptors ka use hota hai.

### **File Descriptor Limits**

- Har operating system ke paas maximum file descriptors ki limit hoti hai jo ek process ke dwara use kiye ja sakte hain. Ye limit `ulimit -n` command se check aur set ki ja sakti hai.
- Agar file descriptors ki limit exceed ho jaati hai, toh `open()` ya koi bhi file operation fail ho sakta hai, usually `EMFILE` (too many open files) error ke saath.

### **File Descriptor Duplication**

- **`dup()` and `dup2()`**: Ye functions file descriptors ko duplicate karne ke liye use hote hain. Ye naye file descriptors create karte hain jo same resource ko point karte hain.
  
  ```c
  int new_fd = dup(fd);  // new_fd ab ussi file ko point karega jo fd karta hai.
  ```

### **File Descriptor Table**

- Har process ke paas ek file descriptor table hota hai jo us process ke saare active file descriptors ko track karta hai. Ye table operating system ke dwara maintain hota hai.
- Jab bhi ek process nayi file open karta hai, toh us table mein ek entry add hoti hai.

### Summary

File descriptor ek unique integer identifier hota hai jo operating system use karta hai resources ko manage karne ke liye. Yeh input/output operations ke liye critical hote hain, aur har open file, socket, ya device ko track karte hain. File descriptors operating system ko help karte hain efficient aur secure resource management mein. 