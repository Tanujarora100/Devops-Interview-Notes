
### 1. **Memory Types:**
   Linux memory ko do main categories mein divide karta hai: **Physical Memory** (RAM) aur **Virtual Memory**.

   - **Physical Memory (RAM)**: Ye woh actual hardware memory hai jo aapke computer mein lagi hoti hai.
   - **Virtual Memory**: Ye ek abstraction layer hai jo har process ko lagega ki uske paas apni dedicated memory hai, `chahe physically utni RAM available ho ya na ho`.

### 2. **Paging and Swapping:**
   - **Paging**: Linux physical memory ko chhote-chhote blocks mein todta hai jisse hum **pages** kehte hain `(usually 4KB size ke)`.
    - Virtual memory bhi pages mein organize hoti hai. Jab koi program ko memory chahiye hoti hai, toh Linux pages allocate karta hai.
   - **Swapping**: Jab RAM poori tarah se bhar jati hai, `toh Linux un pages ko hard disk ke ek swap area mein move kar deta hai` jo actively use nahi ho rahe hote. Isse swap space kehte hain. Jab un pages ki phir se zaroorat hoti hai, toh woh wapas RAM mein load ho jaate hain.

### 3. **Memory Allocation:**
   - Linux mein memory allocate karne ke liye do main methods use hote hain: **Buddy System** aur **Slab Allocator**.
     - **Buddy System**: Isse physical memory ko manage kiya jata hai. Memory ko power-of-two size blocks mein todkar allocate kiya jata hai, jisse fragmentation reduce hota hai.
     - **Slab Allocator**: Ye chhoti size ki memory allocations ke liye use hota hai, jaha pre-allocated memory slabs se chhoti-chhoti memory allocate ki jati hai. Ye efficient hota hai repetitive allocation/deallocation ke liye.

### 4. **Virtual Memory Areas (VMAs):**
   - Har process ka ek virtual address space hota hai jo different **Virtual Memory Areas (VMAs)** mein divide hota hai. 
   - Ek VMA ek contiguous range of addresses ko represent karta hai. Ye data, code, stack, ya shared libraries ko hold kar sakta hai.

### 5. **Page Tables:**
   - Virtual memory addresses ko physical addresses mein map karne ke liye Linux **page tables** use karta hai. 
   - Ye ek tarah ka data structure hota hai jo virtual address ko physical address ke corresponding map karta hai.

### 6. **Cache Management:**
   - **Page Cache**: Linux frequently used disk data ko RAM mein cache karta hai jisse file access fast ho jata hai. Agar file ka data page cache mein hota hai, toh disk se access karne ki zaroorat nahi padti, directly RAM se mil jata hai.
   - **Swap Cache**: Jab pages swap space mein move hote hain, toh swap cache ensure karta hai ki woh page vapas RAM mein load hone par directly access ho sake.

### 7. **Out-of-Memory (OOM) Killer:**
   - Jab system ki saari memory use ho jati hai aur koi bhi free nahi hoti, toh Linux **OOM Killer** activate hota hai. Ye kuch processes ko kill kar deta hai jisse memory free ho sake aur system crash hone se bache.

### 8. **Shared Memory:**
   - Kuch processes ek hi memory ko share kar sakte hain. Isse **Shared Memory** kehte hain. Ye inter-process communication (IPC) ke liye useful hota hai, jisse alag-alag processes efficiently data exchange kar sakte hain bina duplicate kiye.

### 9. **Memory Protection:**
   - Linux har process ko apne memory space mein operate karne deta hai. Agar ek process dusre process ki memory access karne ki koshish karta hai bina permission ke, toh segmentation fault hota hai. Isse system ki stability aur security maintain hoti hai.
# BUDDY SYSTEM VS SLAB ALLOCATOR
### 1. **Buddy System**:

**Buddy System** ek memory allocation technique hai jo physical memory ko efficiently manage karti hai. Ye system large memory blocks ko power-of-two sizes mein todkar chhote blocks mein allocate karta hai. Ye fragmentation ko minimize karta hai aur memory allocation/deallocation ko fast banata hai.

#### **Kaise Kaam Karta Hai**:
- **Memory Blocks**: Buddy system mein memory ko fixed-size blocks mein tod diya jata hai, jise "buddies" kehte hain. Agar ek process ko 64KB memory chahiye aur sirf `128KB ka block available hai, toh 128KB block ko do 64KB` buddies mein tod diya jayega.
  
- **Power of Two**: Memory allocation power-of-two size blocks mein hoti hai. Jaise 4KB, 8KB, 16KB, 32KB, etc. Agar requested size 10KB hai, `toh system 16KB allocate karega kyunki wo next power-of-two size hai`.

- **Splitting and Merging**: Jab ek block allocate kiya jata hai, toh system do buddies create karta hai. Agar unme se ek buddy free ho jaata hai, `toh system unhe merge karke ek bada block bana deta hai. Isse fragmentation reduce hota hai. `

- **Example**:
  - Aapko 16KB ka block chahiye, lekin sirf 32KB ka block available hai. Buddy system 32KB ko do 16KB buddies mein tod dega aur ek buddy ko allocate karega. Jab allocation khatam ho jayega, dono 16KB buddies wapas merge hoke 32KB block ban jaayenge.

#### **Fayde**:
- Fast allocation aur deallocation.
- Less external fragmentation kyunki blocks fixed-size ke hote hain.
- Simple implementation and management.

#### **Nuksaan**:
- Internal fragmentation ho sakti hai jab requested memory size aur allocated size mein difference ho.
- Complexity increase hoti hai jab fragmentation control karna mushkil ho.

### 2. **Slab Allocator**:

**Slab Allocator** ek specialized memory allocator hai jo chhote objects ko efficiently manage karta hai. Ye typically Linux kernel mein use hota hai to manage frequently used data structures.

#### **Kaise Kaam Karta Hai**:
- **Slabs**: Slab allocator memory ko slabs mein todta hai. Ek slab ek ya zyada pages ka hota hai (usually 4KB ka ek page hota hai). Har slab ek specific type ke object ke liye allocate hota hai.

- **Cache**: Slab allocator har object type ke liye ek cache maintain karta hai. Ek cache mein multiple slabs ho sakte hain. Har cache ek hi type ke objects ke liye hota hai. Jab ek object ki zaroorat hoti hai, toh allocator us object type ke cache ko check karta hai.

- **Active, Partial, Free Slabs**: Slabs ko teen categories mein divide kiya jaata hai:
  - **Active**: Slabs jisme saare objects allocated hain.
  - **Partial**: Slabs jisme kuch objects allocated hain aur kuch free hain.
  - **Free**: Slabs jisme koi object allocated nahi hai.

- **Allocation Process**: Jab ek object allocate karna hota hai, toh slab allocator ek partial ya free slab se object allocate karta hai. Agar koi free slab nahi hai, toh nayi slab create ki jaati hai.

#### **Fayde**:
- Efficient allocation for small objects, kyunki same type ke objects ek hi slab mein store hote hain.
- Kam fragmentation kyunki ek slab specific object type ke liye use hota hai.
- Fast allocation and deallocation due to pre-allocated object cache.

#### **Nuksaan**:
- Slab allocator complex hai aur implementation mein careful management ki zaroorat hoti hai.
- Large objects ke liye effective nahi hai, kyunki ye small objects ke liye optimized hai.

### Summary:

- **Buddy System**: General purpose memory allocation ke liye, jo power-of-two size blocks use karta hai aur fragmentation ko minimize karta hai.
- **Slab Allocator**: Specialized allocator, small fixed-size objects ke liye, efficient aur fast memory management ke liye use hota hai.
