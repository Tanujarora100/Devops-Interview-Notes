# Networking

## Configure networking and hostname resolution statically or dynamically

* `ip addr show`

### The hostname can be changed editing `/etc/hostname`
  * Alternative: `hostnamectl set-hostname your-new-hostname` set hostname equal to your-new-hostname

* In `/etc/hosts` is configured a name resolution that take precedence of DNS 

  * It contains static DNS entry
  * It is possible add hostname to row for 127.0.0.1 resolution, or insert a static IP configured on principal interface equal to hostname

*  In `/etc/resolv.conf` there are configured DNS servers entry

  * It is possible to insert more than one *nameserver* as backup (primary and secondary)

## Configure network services to start automatically at boot

Network Manager

* Its purpose is to automatically detect, configure, and connect to a network whether wired or wireless such as VPN, DNS, static routes, addresses, etc which is why you'll see #Configured by NetworkManager in /etc/resolv.conf, for example. Although it will prefer wired connections, it will pick the best known wireless connection and whichever it deems to be the most reliable. It will also switch over to wired automatically if it's there.
  It's not necessary and many (including me) disable it as most would rather manage their own network settings and don't need it done for them.
* `systemctl stop NetworkManager.service`
* `systemctl disable NetworkManager.service`

## Implement packet filtering

* The firewall is managed by Kernel

* The kernel firewall functionality is Netfilter
* Netfilter will process information that will enter and will exit from system
  * For this it has two tables of rules called chains: 
    * *INPUT* that contains rules applied to packets that enter in the system
    * *OUTPUT* that contains rules applied to packets that leave the system
* Another chain can be used if system is configured as router: *FORWARD*
* Finally there are other two chains: PREROUTING, POSTROUTING
* The rules inside chains are evaluated in an orderly way. 

  * When a rule match the other rules are skipped
  * If no rules match, default policy will be applied
    * Default policy:
      * ACCEPT: the packet will be accepted and it will continue its path through the chains
      * DROP: the packet will be rejected

* The utility to manage firewall is `iptables`

* `iptables` will create rules for chains that will be processed in an orderly way

* `firewalld` is a service that use iptables to manage firewalls rules

* `firewall-cmd` is the command to manage firewalld



Firewalld

* firewalld is enabled by default in CentOS
* It works with zone, *public* is default zone
* The *zone* is applied to an interface
  * The idea is that we can have safe zone, e.g. bound to an internal interface, and unsafe zone, e.g. bound to external interfaces internet facing
* `firewall-cmd --list-all` show current configuration
  * services -> service that are allowed to use interface
  * ports -> ports that are allowed to use interface
* `firewall-cmd --get-services` shows the list of default services
  * The services are configured in `/urs/lib/firewalld/services`
  * `/urs/lib/firewalld/services` contains xml file with service configuration

* `firewall-cmd --add-service service` add service to current configuration
  * **NOTE**: it isn't a permanent configuration
* `firewall-cmd --reload` reload firewalld configuration
  * **NOTE**: If a service was added with previous command now it is disappeared
* `firewall-cmd --add-service service --permanent`  add service to configuration as permanent
  * **NOTE**: Now if firewalld configuration is reloaded service it is still present
* `firewall-cmd --add-port 4000-4005/tcp` Open TCP ports from 4000 to 4005
* `firewall-cmd --permanent --direct --add-rule ipv4 filter OUTPUT 1 -p tcp -m tcp --dport 80 -j ACCEPT`
  * Add a firewall rule using iptables syntax
  * This add permanently a rule as first in OUTPUT chain to allow connections to TCP destination port 80



iptables

* The `firewalld` daemon can be substitute with `iptables` daemon (the configuration that was in place until recently)
  * `systemctl stop firewalld`
  * `iptables -L`
    * More verbose output `iptables -L -v`
    * Show configuration of iptables chains
    * Note that policies is set equal to ACCEPT for every chain. This means that no package will be rejected. This is equal to have a shut downed firewall
  * `systemctl disable firewalld`
  * `yum -y install iptables-services`
  * `systemctl enable iptables`



* With this configuration rules must be inserted
* `iptables -P INPUT DROP`
  * Set default policy to DROP for INPUT chain
* iptables rules syntax:
  * `iptables {-A|I} chain [-i/o interface][-s/d ipaddres] [-p tcp|upd|icmp [--dport|--sport nn…]] -j [LOG|ACCEPT|DROP|REJECT]`
  * `{-A|I} chain`
    * `-A` append as last rule
    * `-I` insert. This require a number after chain that indicate rule position
  * `[-i/o interface]`
    * E.g. `-i eth0` - the package is received (input) on the interface eth0
  * `[-s/d ipaddres]`
    * `-s` Source address. ipaddres can be an address or a subnet
    * `-d` Destination address. ipaddres can be an address or a subnet
  * [-p tcp|upd|icmp [--dport|--sport nn…]]
    * `-p` protocol
    * `--dport` Destination port
    * `--sport` Source port
  * `-j [LOG|ACCEPT|DROP|REJECTED]`
    * `ACCEPT` accept packet
    * `DROP` silently rejected
    * `REJECT` reject the packet with an ICMP error packet
    * `LOG` log packet. <u>Evaluation of rules isn't blocked.</u>

* E.g.
* `iptables -A INPUT -i lo -j ACCEPT` 
  * Accept all inbound loopback traffic
* `iptables -A OUTPUT -o lo -j ACCEPT`
  * Accept all outbound loopback traffic
* `iptables -A INPUT -p tcp --dport 22 -j ACCEPT`
  * Accept all inbound traffic for tcp port 22
* `iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT`
  * This is a rule that is used to ACCEPT all traffic generated as a response of an inbound connection that was accepted. E.g. if incoming traffic for web server on port 80 was accepted, this rule permits to response traffic to exit from system without inserting specific rules in OUTPUT chain



* **NOTE** file `/etc/services` contains a list of well know ports with services name

## Start, stop, and check the status of network services

* Network services are controlled as other daemon with `systemctl` command
  * `systemctl status servicename`



* With `netstat` is it possible list internet port opened by a process
  * `yum -y install net-tools`
  * `netstat -tln`
    * Show TCP port opened by processes



## Statically route IP traffic

* `ip route show`
  * Print route
  * Alternative command `route -n`
* `ip route add 192.0.2.1 via 10.0.0.1 [dev interface]`
  * Add route to 192.0.2.1 through 10.0.0.1. Optionally interface can be specified
* To make route persistent, create a *route-ifname* file for the interface through which the subnet is accessed, e.g eth0:
  * `vi /etc/sysconfig/network-scripts/route-eth0`
  * Add line `192.0.2.1 via 10.0.0.101 dev eth0`
  * `service network restart` to reload file

* `ip route add 192.0.2.0/24 via 10.0.0.1 [dev ifname]` 
  * Add a route to subnet 192.0.2.0/24



* To configure system as route forward must be enabled
  * `echo 1 > /proc/sys/net/ipv4/ip_forward`
  * To make configuration persistent
    * `echo net.ipv4.ip_forward = 1 > /etc/sysctl.d/ipv4.conf`

References:

* [https://my.esecuredata.com/index.php?/knowledgebase/article/2/add-a-static-route-on-centos](https://my.esecuredata.com/index.php?/knowledgebase/article/2/add-a-static-route-on-centos)



## Synchronize time using other network peers

* In time synchronization the concept of Stratum define the accuracy of server time.
* A server with Stratum 0 it is the most reliable
* A server synchronized with a Stratum 0 become Stratum 1
* Stratum 10 is reserved for local clock. This means that it is not utilizable
* The upper limit for Stratum is 15
* Stratum 16 is used to indicate that a device is unsynchronized
* Remember that time synchronization between servers is a slowly process



CHRONYD

* Default mechanism to synchronize time in CentOS
* Configuration file `/etc/chrony.conf`
* `server` parameters are servers that are used as source of synchronization
* `chronyc sources` contact server and show them status
* `chronyc tracking` show current status of system clock



* **NOTE**: if some of the commands below doesn't work please refer to this bug [https://bugzilla.redhat.com/show_bug.cgi?id=1574418](https://bugzilla.redhat.com/show_bug.cgi?id=1574418)
  * Simple solution: `setenforce 0`
  * Package `selinux-policy-3.13.1-229` should resolve problem



NTP

* The old method of synchronization. To enable it Chronyd must be disabled
* Configuration file `/etc/ntp.conf`
* `server` parameters are servers that are used as source of synchronization
* `ntpq -p` check current status of synchronization
## What are cgroups?

Control groups (cgroups) are a Linux kernel feature that allows you to allocate, limit, and isolate the resource usage (such as CPU time, system memory, disk I/O, and network bandwidth) of a collection of processes. Cgroups provide fine-grained control over how resources are allocated to different processes or groups of processes, enabling system administrators to manage system performance, prioritize tasks, and ensure resource availability.

### Key Features of cgroups

1. **Resource Limiting**: Set limits on the amount of resources that a group of processes can use. For example, you can limit the memory usage of a cgroup to prevent it from consuming all available memory.
2. **Prioritization**: Allocate more resources to certain cgroups over others. For example, you can prioritize CPU time for critical applications.
3. **Accounting**: Monitor and report the resource usage of cgroups, which can be useful for billing or resource management purposes.
4. **Control**: Freeze, stop, or restart all processes within a cgroup with a single command.

### Hierarchical Organization

Cgroups are organized hierarchically, meaning that you can create parent and child cgroups. Resource limits set on a parent cgroup are inherited by its child cgroups, allowing for structured and granular resource management.

### Subsystems (Controllers)

Cgroups use various subsystems (also known as controllers) to manage different types of resources. Some common subsystems include:
- **cpu**: Controls CPU scheduling and usage.
- **memory**: Limits and accounts for memory usage.
- **blkio**: Controls and monitors access to block devices (e.g., disk I/O).
- **net_cls**: Tags network packets for traffic control.
- **cpuset**: Assigns CPUs and memory nodes to tasks.

## Scenario for Using cgroups

### Scenario: Isolating Resources for a Web Server and a Database Server

### Steps to Implement cgroups

1. **Create cgroups for the Web Server and Database Server**:
   ```bash
   sudo cgcreate -g cpu,memory:/webserver
   sudo cgcreate -g cpu,memory:/dbserver
   ```

2. **Set Resource Limits**:
   - **Web Server**:
     ```bash
     sudo cgset -r cpu.shares=512 /webserver
     sudo cgset -r memory.limit_in_bytes=1G /webserver
     ```
   - **Database Server**:
     ```bash
     sudo cgset -r cpu.shares=1024 /dbserver
     sudo cgset -r memory.limit_in_bytes=2G /dbserver
     ```

3. **Assign Processes to cgroups**:
   - Start the web server within the `webserver` cgroup:
     ```bash
     sudo cgexec -g cpu,memory:/webserver /path/to/webserver
     ```
   - Start the database server within the `dbserver` cgroup:
     ```bash
     sudo cgexec -g cpu,memory:/dbserver /path/to/dbserver
     ```
