
### **EFI Partition (used in UEFI booting)**:
- **Full Form**: EFI stands for **Extensible Firmware Interface**.
- **Used by UEFI**: Modern computers use **UEFI**instead of the older BIOS.
- **EFI Partition**: Instead of storing boot information in a small space like MBR, UEFI systems have a dedicated partition called the **EFI System Partition (ESP)**. This partition stores GRUB files for the operating system(s) and other related data.
- **Supports Large Drives**: UEFI with an EFI partition uses **GPT (GUID Partition Table)**, which allows drives larger than 2TB and can support many partitions.
- **More Secure**: UEFI systems can implement **Secure Boot**.

### **MBR (Master Boot Record)**:
- **Full Form**: MBR stands for **Master Boot Record**.
- **Used by BIOS**: Older systems that use **BIOS** rely on the MBR to boot the operating system.
- **MBR Size**: MBR is a small section (512 bytes) located at the very start of the storage drive. 
    - It holds information about how the disk is partitioned and contains a small bootloader program.
- **Limited to Smaller Drives**: MBR can only handle drives up to **2TB** and can define a maximum of **4 primary partitions**.
- **Less Secure**: BIOS/MBR does not support modern security features like Secure Boot.

### Key Differences:
- **Boot Storage Location**: MBR uses a small area at the start of the disk; EFI uses a dedicated partition.
- **Partition Table**: MBR uses the older partitioning scheme, while UEFI uses GPT, which supports more and larger partitions.
- **Drive Size**: MBR is limited to 2TB drives, while GPT (used with UEFI) supports much larger drives.
- **Security**: UEFI can use Secure Boot

