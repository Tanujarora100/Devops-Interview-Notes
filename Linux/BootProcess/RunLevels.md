
## Standard Runlevels in Linux
- **Runlevel S or 1**: Often referred to as single-user mode, used for maintenance and administrative tasks. 
- **Runlevel 2**: Typically used for multi-user mode but without NFS (Network File System) services.
- **Runlevel 3**: Commonly used for multi-user mode with networking, but without a graphical interface.
- **Runlevel 4**: Rarely used, can be customized by the user for specific needs.
- **Runlevel 5**: Standard for systems that boot into a graphical user interface (GUI).
- **Runlevel 6**: Used to reboot the system.

## Viewing and Changing Runlevels
```bash
who -r
```
### Setting the Default Runlevel
For systems using `systemd`, the default target (equivalent to runlevel) can be set using the `systemctl` command. 
```bash
who -r
    run-level 5  2024-08-22 03:49
systemctl get-default
    graphical.target
```
```bash
sudo systemctl set-default graphical.target
```

### Common Systemd Targets

| **Target**             | **Description**                                |
|------------------------|------------------------------------------------|
| `poweroff.target`      | Equivalent to runlevel 0 (shuts down the system). |
| `rescue.target`        | Equivalent to runlevel 1 (single-user mode).     |
| `multi-user.target`    | Equivalent to runlevel 3 (multi-user mode with networking). |
| `graphical.target`     | Equivalent to runlevel 5 (multi-user mode with GUI). |
| `reboot.target`        | Equivalent to runlevel 6 (reboots the system).   |

### Viewing and Changing Targets


```bash
systemctl get-default
```

```bash
sudo systemctl isolate multi-user.target
```

### How Runlevels Work:
- The **init** system determines which runlevel the system should boot into by checking the configuration file (`/etc/inittab`).
- When changing runlevels (e.g., from runlevel 3 to 5), the system starts and stops the services associated with those runlevels.

### Limitations of SysV:
- SysVinit processes each runlevel sequentially
- Starts each service one by one.
- Dependency Management is weaker here.

### 2. **systemd Targets**

**systemd** is the modern initialization system replacing SysVinit in most Linux distributions. Instead of **runlevels**, systemd uses **targets**, which define the system's state and which services are active.

#### **Key Features of systemd**:
- systemd starts services in parallel, reducing boot time.
- systemd can handle service dependencies more intelligently than SysVinit.
- **Unified Configuration**: systemd unifies system configurations using unit files (`*.service`, `*.target`, etc.).

#### **Common systemd Targets**:
1. **poweroff.target**: Equivalent to Runlevel 0 (Shutdown).
2. **rescue.target**: Equivalent to Runlevel 1 (Single-user mode for recovery or maintenance).
3. **multi-user.target**: Equivalent to Runlevel 3 (Full multi-user text mode with networking).
4. **graphical.target**: Equivalent to Runlevel 5 (Full multi-user mode with a GUI).
5. **reboot.target**: Equivalent to Runlevel 6 (Reboot).
6. **emergency.target**: Minimal boot-up for emergency troubleshooting, more restrictive than `rescue.target`.

### systemd Target vs. SysV Runlevel Mapping:

| SysV Runlevel | systemd Target Equivalent     | Description                                    |
|---------------|-------------------------------|------------------------------------------------|
| 0             | `poweroff.target`             | Power off the system                           |
| 1             | `rescue.target`               | Single-user mode, maintenance                  |
| 2             | `multi-user.target`           | Multi-user mode (without networking)           |
| 3             | `multi-user.target`           | Multi-user mode (with networking)              |
| 5             | `graphical.target`            | Multi-user mode with graphical interface       |
| 6             | `reboot.target`               | Reboot the system                              |

### How systemd Targets Work:
- **Default Target**: The default target is specified by a symbolic link from `/etc/systemd/system/default.target` to one of the target files (e.g., `multi-user.target` or `graphical.target`).
- This file is a direct link to the specific target at that time.
- **Switching Targets**: To change the system state, you can switch targets using the `systemctl isolate <target>` command.
  - Example: `systemctl isolate graphical.target` will switch the system to graphical mode.
  
### Example systemd Commands:
- **Check Current Target**: `systemctl get-default`
- **Set Default Target**: `systemctl set-default <target>`
  - Example: `systemctl set-default multi-user.target`
- **Switch to Target**: `systemctl isolate <target>`
  - Example: `systemctl isolate rescue.target` (switch to rescue mode).

#### Steps to Create a Custom Target:
1. Create a new target file (e.g., `/etc/systemd/system/mycustom.target`).
2. Define the services or targets it should start by adding `[Unit]` and `[Install]` sections to the target file.
3. Use `systemctl` to enable and activate the new target.
