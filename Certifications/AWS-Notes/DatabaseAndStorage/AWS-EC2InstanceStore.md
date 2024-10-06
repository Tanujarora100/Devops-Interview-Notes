- **Hardware storage directly attached to EC2 instance** (cannot be detached and attached to another instance)
- **Highest IOPS** of any available storage (millions of IOPS)
- **Ephemeral storage** (loses data when the instance is stopped, **hibernated** or terminated)
- Data is not lost when it is restarted.
- Good for buffer / cache / scratch data / temporary content
- AMI created from an instance does not have its instance store volume preserved

<aside>
💡 You can specify the instance store volumes only when you launch an instance. You can’t attach instance store volumes to an instance after you’ve launched it.

</aside>

## RAID

- **RAID 0**
    - Improve `performance of a storage volume by distributing reads & writes in a stripe across attached volumes`
    - For high performance applications
- **RAID 1**
    - Improve `data availability` by mirroring data in multiple volumes
    - For critical applications