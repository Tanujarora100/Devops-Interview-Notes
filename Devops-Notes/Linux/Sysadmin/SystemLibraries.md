## System Libraries in Linux
### Types of Libraries
1. **Static Libraries**:
   - **File Extension**: `.a` (archive)
   - **Characteristics**: 
     - Linked at compile time.
     - Each process has its own copy of library
     - It increases the size of the process.

2. **Dynamic (Shared) Libraries**:
   - **File Extension**: `.so`
   - **Characteristics**:
     - Linked at runtime 
     - Multiple programs can share a single copy
     - Easier to update since changes to the library do not require recompiling dependent executables.

### Library Paths

- **Standard Library Paths**:
  - `/lib`
  - `/lib64`
  - `/usr/lib`
  - `/usr/lib64`
  - `/usr/local/lib`
  - `/usr/local/lib64`

- **System Startup Libraries**:
### Dynamic Loader
The dynamic loader (`ld.so` or `ld-linux.so`) is responsible for loading shared libraries needed by a program at runtime.

### Checking Installed Libraries
To check if a specific shared library is installed on your system, you can use the `ldconfig` command:

```bash
ldconfig -p | grep libpthread.so.0
```


## HOW DYNAMIC LOADER WORKS:

1. **Loading the Program**:
   - Kernel loads the program
   - Kernel looks for the interpreter or dynamic loader specified in the executable.

2. **Resolving Dependencies**:
   - The dynamic loader reads the executable's dynamic section to determine which shared libraries are needed. These dependencies are typically listed in the `.dynamic` section of the ELF file.

3. **Loading Shared Libraries**:
   - The dynamic loader loads the shared libraries into memory. If any of these libraries have their own dependencies, those are loaded recursively.

4. **Symbol Resolution**:
   - The dynamic loader resolves symbols (functions and variables) used by the executable to the appropriate memory addresses in the shared libraries.
   - If a symbol is not found, the loader will generate an error, often leading to the program being terminated.

5. **Relocation**:
   - If necessary, the dynamic loader performs relocation, which involves adjusting the addresses in the code so that they point to the correct memory locations.


### Environment Variables Affecting the Dynamic Loader

- **LD_LIBRARY_PATH**: Specifies a list of directories to search for shared libraries before the default paths.
- **LD_PRELOAD**: Forces the dynamic loader to load specified libraries before any others, which is useful for overriding specific library functions.
- **LD_DEBUG**: Provides debug information from the dynamic loader about the libraries being loaded and the symbols being resolved.

### Practical Use

You can check which shared libraries a program depends on using the `ldd` command:

```bash
ldd /path/to/executable
```

This command lists all shared libraries required by the executable and their paths.

### Example Scenario

If you're developing or deploying software, understanding how the dynamic loader works is crucial when dealing with issues like missing dependencies, version conflicts, or when trying to override specific library functions using tools like `LD_PRELOAD`.

