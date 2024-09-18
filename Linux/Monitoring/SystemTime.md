## CHRONYD
* Default mechanism to synchronize time in CentOS
* Configuration file `/etc/chrony.conf`
* `server` parameters are servers that are used as source of synchronization
* `chronyc sources` contact server and show them status
* `chronyc tracking` show current status of system clock


## NTP

* The old method of synchronization. To enable it Chronyd must be disabled
* Configuration file `/etc/ntp.conf`
* `server` parameters are servers that are used as source of synchronization
* `ntpq -p` check current status of synchronization
