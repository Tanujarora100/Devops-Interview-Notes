# BIOS/UEFI
### 1. **BIOS/UEFI**

- **BIOS (Basic Input/Output System)**:
  - Found in older systems 
  - Initialize the hardware and look for a boot device
  - **Power-On Self Test (POST)** to ensure the system hardware is working correctly.
  - After POST, it checks the boot order (configured in BIOS settings) to find a device with a bootable master boot record (MBR).
  - It uses the MBR, which contains the bootloader, to load the next stage of the boot process.

- **UEFI (Unified Extensible Firmware Interface)**:
  - UEFI is a modern replacement for BIOS
  - better graphical interfaces, and the ability to `handle larger boot disks (>2TB)` using the GPT (GUID Partition Table) instead of MBR.
  - supports **secure boot**, a feature that ensures only signed bootloaders and OS kernels are executed, which enhances security.
  - UEFI directly loads the bootloader (such as GRUB) from the EFI partition, bypassing the need for an MBR.

**Key Differences**:
- UEFI supports larger disks and more modern features like Secure Boot, whereas BIOS is limited to MBR and older hardware.
- UEFI can boot from both `GPT and MBR partitions`, while BIOS can only boot from `MBR partitions`.

### 2. **GRUB (Grand Unified Bootloader)**

- **GRUB** is the bootloader used by many Linux distributions. Its role is to load and transfer control to the Linux kernel.

**GRUB Boot Stages**:
- **Stage 1**: GRUB is loaded by BIOS/UEFI from the MBR or dedicated EFI partition in UEFI based linux.
- **Stage 1.5**: If the file system is not recognized directly, Stage 1.5 is used to load the file system modules (this step is omitted in UEFI-based systems).
- **Stage 2**: GRUB Stage 2 presents a menu that allows users to choose which OS or kernel to boot. It loads the selected kernel into memory and transfers control to it.
- Basic Job is to load the kernel in the memory.

**Key GRUB Configurations**:
- Configuration files for GRUB are stored in `/boot/grub/grub.cfg`.
- GRUB supports **multiple kernels** and allows users to pass **kernel parameters** (like `init=/bin/bash`)

### 3. **initrd and initramfs**

- **initrd (Initial RAM Disk)**:
  - **initrd** is a precompiled image that the GRUB loads into memory before the actual file system is mounted. 
  - It contains a minimal set of drivers necessary to mount the root file system (e.g., SCSI, LVM, or RAID drivers).
  - After the root file system is mounted, `initrd` is unmounted, and the system transitions to the real root file system.
  - It was mainly used with older Linux systems.

- **initramfs (Initial RAM File System)**:
  - **initramfs** is a more modern replacement for `initrd`
  - `initramfs` includes kernel modules, user-space utilities, and scripts that prepare the system for booting into the root file system.
  - It remains in memory throughout the boot process, unlike `initrd`, which is eventually discarded.


### 4. **Full Linux Boot Process**
# BOOT PROCESS:
1. **Power On Karna**: Jab aap computer ko power on karte ho, toh sabse pehle BIOS ya UEFI activate hota hai. 
    - Ye basic software hai jo hardware ko check karta hai aur ensure karta hai ki sab kuch thik se kaam kar raha hai.

2. **Bootloader Load Hota Hai**: BIOS/UEFI bootloader ko dhundta hai aur usse load karta hai. 
    - Common bootloader jo Linux use karta hai wo hai GRUB (Grand Unified Bootloader). 
    - Bootloader ka kaam hota hai operating system ko load karne mein help karna.

3. **Kernel Load Hota Hai**: Bootloader kernel ko load karta hai. Kernel Linux ka core part hota hai jo computer ke hardware aur software ke beech mein bridge ka kaam karta hai. 
    - `Ye RAM mein load hota hai`.

4. **Initial RAM Disk (initrd/initramfs) Load Hota Hai**: Ye ek temporary root file system hai jo kuch zaroori drivers aur modules load karta hai jab tak real root file system mount nahi ho jata.

5. **Root File System Mount Hota Hai**: Ab kernel actual root file system ko mount karta hai jaha se sabhi system files aur directories hoti hain. `Ye root file system hard drive par hota hai.`

6. **Init Process Start Hoti Hai**: Root file system mount hone ke baad, init process start hoti hai. 
    - Init system ka pehla process hota hai aur isi se saare doosre processes start hote hain. 
    - Modern Linux systems mein, systemd init system hota hai jo boot process ko manage karta hai.

7. **System Services Start Hoti Hain**: Init/systemd different system services ko start karta hai jaise network services, login services, etc.

8. **Login Screen Aata Hai**: Sab services start hone ke baad, user ko login prompt ya graphical login screen dikhta hai. Ab aap apna username aur password dal kar system use kar sakte ho.

