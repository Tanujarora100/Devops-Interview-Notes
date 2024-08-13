
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
### Changing Runlevels
```bash
sudo init 3
```
or
```bash
sudo telinit 3
```

### Setting the Default Runlevel
For systems using `systemd`, the default target (equivalent to runlevel) can be set using the `systemctl` command. For example, to set the default target to graphical mode:

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



