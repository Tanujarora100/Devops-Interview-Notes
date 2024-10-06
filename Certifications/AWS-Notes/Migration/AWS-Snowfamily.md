The AWS Snow Family is designed to help customers collect and process data in edge locations and transfer data into and out of AWS.

### AWS Snowcone
- **Size and Portability**: The `smallest member` of the Snow Family
- **Storage**: 8 TB
- **Connectivity**: Can be sent back to AWS for data transfer or use AWS DataSync for online data transfer.
- **Computing**: Supports `AWS IoT Greengrass`,`Lambda` and can run `Amazon EC2 instances` on the device.

### AWS Snowball Edge
- **Variants**: Snowball Edge Compute Optimized and Snowball Edge Storage Optimized.
- **Storage**: Up to `80 TB of usable storage` in storage optimized
    - Offers 42 TB in computer optimized.
- **Computing**: The Compute Optimized option includes additional compute capacity, with support for `EC2 instances and AWS Lambda`.
- **Features**: Integrated with AWS IoT Greengrass, optional GPU, local storage

### AWS Snowmobile
- **Scale**: An `exabyte-scale` data transfer service
- **Storage**: Each Snowmobile is a `45-foot long ruggedized shipping container`, capable of carrying up to `100 PB of data`.
- **Security**: Armed with end-to-end encryption, GPS tracking, 24/7 video surveillance, and escort security during transit.

### Common Features Across the Snow Family
- **Data Security**: All data stored on the Snow Family devices is automatically encrypted using (KMS).
- **Operational Models**: Customers can perform local processing and collection at the edge, then physically transport the devices to AWS for data ingestion, or use AWS DataSync for online data transfer.
