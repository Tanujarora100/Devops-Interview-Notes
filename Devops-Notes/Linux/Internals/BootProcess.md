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
