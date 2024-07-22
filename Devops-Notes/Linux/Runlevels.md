Runlevels in Linux are predefined states that a system can be in, each characterized by a specific set of services and processes that are either running or stopped.

## Standard Runlevels in Linux

| **Runlevel** | **Description**                                                                                     |
|--------------|-----------------------------------------------------------------------------------------------------|
| 0            | **Halt**: Shuts down the system safely.                                                             |
| 1            | **Single-user mode**: For administrative tasks; no network services are started.                    |
| 2            | **Multi-user mode without networking**: Multiple users can log in, but no network services are started.|
| 3            | **Multi-user mode with networking**: Standard runlevel for most servers; multi-user mode with networking.|
| 4            | **Not used/User-definable**: Can be customized for specific purposes.                               |
| 5            | **Multi-user mode with GUI**: Similar to runlevel 3 but with a graphical user interface.            |
| 6            | **Reboot**: Reboots the system.                                                                     |

### Additional Details

- **Runlevel S or 1**: Often referred to as single-user mode, used for maintenance and administrative tasks. It is a minimal environment with only essential services running.
- **Runlevel 2**: Typically used for multi-user mode but without NFS (Network File System) services.
- **Runlevel 3**: Commonly used for multi-user mode with networking, but without a graphical interface.
- **Runlevel 4**: Rarely used, can be customized by the user for specific needs.
- **Runlevel 5**: Standard for systems that boot into a graphical user interface (GUI).
- **Runlevel 6**: Used to reboot the system.

## Viewing and Changing Runlevels

### Viewing the Current Runlevel
To check the current runlevel, you can use the following commands:

```bash
runlevel
```
or
```bash
who -r
```

### Changing Runlevels
To change the runlevel, you can use the `init` or `telinit` command followed by the desired runlevel number. For example:

```bash
sudo init 3
```
or
```bash
sudo telinit 3
```

### Setting the Default Runlevel
The default runlevel is specified in the `/etc/inittab` file for systems using SysVinit. For example:

```plaintext
id:5:initdefault:
```

For systems using `systemd`, the default target (equivalent to runlevel) can be set using the `systemctl` command. For example, to set the default target to graphical mode:

```bash
sudo systemctl set-default graphical.target
```

## Systemd and Targets

Most modern Linux distributions have moved from SysVinit to `systemd`, which uses targets instead of runlevels. Targets provide more flexibility and features compared to traditional runlevels.

### Common Systemd Targets

| **Target**             | **Description**                                |
|------------------------|------------------------------------------------|
| `poweroff.target`      | Equivalent to runlevel 0 (shuts down the system). |
| `rescue.target`        | Equivalent to runlevel 1 (single-user mode).     |
| `multi-user.target`    | Equivalent to runlevel 3 (multi-user mode with networking). |
| `graphical.target`     | Equivalent to runlevel 5 (multi-user mode with GUI). |
| `reboot.target`        | Equivalent to runlevel 6 (reboots the system).   |

### Viewing and Changing Targets

To view the current target:

```bash
systemctl get-default
```

To change the current target:

```bash
sudo systemctl isolate multi-user.target
```



