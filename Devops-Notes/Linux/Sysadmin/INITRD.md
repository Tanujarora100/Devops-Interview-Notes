### INITRD (Initial RAM Disk)

**INITRD (Initial RAM Disk)** is a temporary file system used in the Linux boot process.
- It is a temporary file system loaded by the kernel at the boot process to facilitate the loading of the operating system.
- It helps in mounting of the root filesystem also.

#### Purpose and Function of INITRD

1. **Modular Kernel Support:**
   - Modern Linux kernels are modular, meaning not all drivers and components are built directly into the kernel. INITRD provides the required modules that the kernel might need to access the root file system.

2. **Hardware Initialization:**
   - INITRD helps in initializing hardware that is essential for mounting the root file system. This includes drivers for storage controllers.

3. **System Boot Flexibility:**
   - By using INITRD, the same kernel can be used across different hardware configurations. The specific drivers and modules required for a particular system can be loaded dynamically during the boot process.

4. **Support for Complex Root File Systems:**
   - If the root file system is on a device that requires additional setup (e.g., a RAID array, encrypted partition, or network file system), INITRD provides the necessary tools and scripts to set up these devices before switching to the real root file system.

#### Structure of INITRD

- **Image File:**
  - INITRD is typically an image file that contains a compressed file system (often using formats like gzip, cpio, or initramfs).
  - This image file is loaded into memory by the bootloader.

- **Initialization Scripts:**
  - Inside the INITRD image, there are scripts that execute during the boot process. These scripts handle tasks like loading drivers, setting up devices, and mounting the root file system.

- **Kernel Modules:**
  - The image includes kernel modules (drivers) that are not built into the kernel but are necessary for booting the system.

#### Boot Process with INITRD

1. **Bootloader Stage:**
   - The bootloader (e.g., GRUB, LILO) loads the kernel and the INITRD image into memory.

2. **Kernel Initialization:**
   - The kernel initializes and mounts the INITRD as a temporary root file system.
   - The kernel executes the initialization scripts within the INITRD.

3. **Hardware and Driver Initialization:**
   - The initialization scripts load necessary drivers and set up hardware required for the root file system.

4. **Root File System Mounting:**
   - After initializing hardware and loading drivers, the scripts mount the real root file system (specified in the bootloader configuration).

5. **Switch to Real Root File System:**
   - The system switches from the INITRD to the real root file system using the `pivot_root` or `switch_root` command.
   - The INITRD is then unmounted and freed from memory.

6. **Continue Boot Process:**
   - The system continues the normal boot process from the real root file system, leading to the initialization of user space and starting system services.

#### Example Workflow

1. **GRUB Configuration:**
   - GRUB is configured to load the kernel and INITRD image.
   - Example entry in `/boot/grub/grub.cfg`:
     ```plaintext
     menuentry 'Linux' {
         set root='hd0,msdos1'
         linux /vmlinuz-linux root=/dev/sda1
         initrd /initramfs-linux.img
     }
     ```

2. **Kernel and INITRD Loading:**
   - GRUB loads `/vmlinuz-linux` (kernel) and `/initramfs-linux.img` (INITRD image).

3. **Kernel Executes INITRD:**
   - Kernel mounts the INITRD as its root file system and runs the initialization scripts.

4. **Initialization Scripts in INITRD:**
   - Scripts in INITRD load necessary modules and drivers.
   - Example script snippet in INITRD:
     ```sh
     # Load necessary modules
     modprobe ahci
     modprobe ext4
     
     # Mount the real root file system
     mount /dev/sda1 /mnt/root
     
     # Switch to the real root file system
     exec switch_root /mnt/root /sbin/init
     ```

5. **Transition to Real Root File System:**
   - The script mounts `/dev/sda1` (real root file system) and switches to it.
   - The system continues booting from the real root file system.

