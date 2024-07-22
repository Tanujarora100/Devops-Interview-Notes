## System Libraries in Linux
### Types of Libraries
Linux systems primarily use two types of libraries:
1. **Static Libraries**:
   - **File Extension**: `.a` (archive)
   - **Characteristics**: 
     - Statically linked into programs during the compilation phase.
     - **Each executable contains its own copy of the library code**.
   - **Usage**: Provides faster execution since all code is included in the executable, but increases the size of the executable.

2. **Dynamic (Shared) Libraries**:
   - **File Extension**: `.so` (shared object)
   - **Characteristics**:
     - Linked at runtime rather than compile time.
     - Multiple programs can share a single copy of the library, reducing memory usage.
     - Easier to update since changes to the library do not require recompiling dependent executables.
   - **Usage**: Preferred for most applications.

### Library Paths

Libraries in Linux are stored in specific directories, and the system uses these paths to locate the necessary libraries:

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
