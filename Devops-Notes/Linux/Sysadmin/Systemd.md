## Services
- Common examples of services include the `sshd` service, which initiates an SSH server, and the `httpd` service, responsible for web server functionalities using HTTP and/or HTTPS protocols.


```
+--------------------------------------------------+
|                Linux Operating System            |
|                                                  |
|    +------------------------+   +-------------+  |
|    |     Service Manager    |   |             |  |
|    |     (e.g., systemd)    |<--|  User       |  |
|    +------------------------+   |  Commands   |  |
|         |         ^             | (e.g.,      |  |
|         |         |             |  systemctl  |  |
|    Start|         |Stop/Restart |  start/stop |  |
|     /Enable       | /Disable    |  /status)   |  |
|         v         |             +-------------+  |
|    +------------------------+                    |
|    |      Linux Service     |                    |
|    |                        |                    |
|    | - Runs in background   |                    |
|    | - Performs tasks       |                    |
|    | - Listens to events    |                    |
|    | - Logs activity        |                    |
|    | - Responds to          |                    |
|    |   service manager      |                    |
|    +------------------------+                    |
|                                                  |
+--------------------------------------------------+
```


## Daemons vs services
The fundamental difference lies in their operational scope and interaction: daemons typically perform dedicated tasks or services autonomously, while services facilitate interactions with other system components.

## Managing Services
#### Enabling Services

```bash
systemctl enable httpd.service
```

#### Disabling Services

II. Using `systemctl` for SystemD-based systems:

```bash
systemctl disable httpd.service
```

This command tells systemd to start the httpd service right away.

#### Stopping Services

```bash
systemctl stop httpd.service
```
### Checking the Status of a Service

The status of a service shows its current state and if it is active or not. Some common service statuses include:

| Status | Description |
| --- | --- |
| `Loaded` | The unit file was processed, and the unit is now active. |
| `Active(running)` | The unit is active with one or more processes.|
| `Active(exited)` | A one-time task was successfully performed. |
| `Active(waiting)` | The unit is active and waiting for an event. |
| `Inactive` | The unit is not running.  |
| `Enabled` | The unit will be started at boot time. |
| `Disabled` |The unit will not be started at boot time. |
| `Static` | The unit can't be enabled, but can be started by another unit manually. |

```
systemctl status httpd.service
```

### Checking Service Dependencies

To check whether a particular service is dependent on a specific target or another service, the `systemctl` command can be utilized in conjunction with `grep`. 
```bash
systemctl list-dependencies [target/service] | grep [service-name]
```bash
systemctl list-dependencies multi-user.target | grep httpd
```

Interpretation of Results
## Creating a Custom Service with SystemD

Creating a custom service in SystemD involves writing a service unit file. 
**This file is a configuration script that provides instructions to SystemD on how to manage and execute the service. These scripts are typically placed in the `/etc/systemd/system/` directory.**
 A service script is divided into several sections, each serving a specific purpose.

### Common Sections in a Service Script
- `[Unit]`: This section provides a description of the service and defines its dependencies. 
- Key directives in this section can include `Description`, which gives a brief description of the service, `Documentation`, providing links to the relevant documentation, and `After`, specifying the order of service startup relative to other units.

- `[Service]`: This section details how the service should be started, stopped, and how it should respond under various conditions. Common directives here include `Type`, defining the startup behavior of the service; `ExecStart`, specifying the command to run when the service starts; `ExecStop` and `ExecReload`, defining the commands to stop and reload the service; and `Restart`, specifying the service's restart behavior.

- `[Install]`: This section is used to define how the service integrates into the system's boot process. It typically includes directives like `WantedBy` and `RequiredBy`, which specify the targets that should include this service during their initialization.

### Example of a Simple Service Script

Below is an example of a basic service script. This script configures SystemD to run a specific executable file at startup:

```systemd
[Unit]
Description=Sample Script Service

[Service]
Type=idle
ExecStart=/valid/path/to/an/executable/file

[Install]
WantedBy=multi-user.target
```

This script includes:

- `Description`: A brief explanation of the service.
- `Type=idle`: Indicates that the service should be started after all jobs are dispatched.
- `ExecStart`: The path to the executable file that will be run when the service starts.
- `WantedBy=multi-user.target`: Specifies that the service should be started under the `multi-user.target`, which is a standard target for creating a multi-user environment.


After creating or modifying a service script, use `systemctl daemon-reload` to reload the SystemD configuration and `systemctl enable [service-name].service` to enable the service.

1. The file is named with a `.service` extension, for example, `my_custom_service.service`.
2. The `[service-name]` is the filename without the `.service` extension, i.e., `my_custom_service` in this example.


- To enable the service: `systemctl enable my_custom_service.service`
- To start the service: `systemctl start my_custom_service.service`
- To check the service status: `systemctl status my_custom_service.service`
