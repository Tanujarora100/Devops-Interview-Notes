# INITRD VS INITRAMFS:
### **initrd (Initial RAM Disk)**:
- `initrd` was used in earlier Linux systems.
- **Disk Image**: It is a disk image that contains a minimal file system used during boot to help the kernel mount the real root file system.
- **Mounting Required**: `initrd` is mounted as a temporary root file system, and after the actual root file system is mounted, `initrd` is unmounted and discarded.
- **Separate File System**: It typically uses a file system like ext2, which needs to be mounted.


### **initramfs (Initial RAM File System)**:
-  `initramfs` is the modern replacement for `initrd`
- **CPIO Archive**: `initramfs` is a compressed archive (usually `cpio`) that contains the necessary files, modules, and scripts to boot the system and mount the real root file system.
- **No Mounting**: Unlike `initrd`, `initramfs` doesn't need to be mounted. The files from `initramfs` are directly unpacked into RAM and used by the kernel during boot.
- **Stays in Memory**: `initramfs` remains in memory after the root file system is mounted. It doesn’t need to be explicitly unmounted like `initrd`.


