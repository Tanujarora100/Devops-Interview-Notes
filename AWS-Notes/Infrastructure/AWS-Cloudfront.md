## Intro

- Global CDN that caches content at edge locations, reducing load at the origin
- **TTL (0 sec - 1 year)** can be set by the origin using headers
- Supports **Server Name Indication (SNI)** to allow SSL traffic to multiple domains
- **CloudFront Geo Restriction** can be used to allow or block countries from accessing a distribution.
- **Edge Locations are present outside the VPC** so the origin's SG must be configured to allow inbound requests from the list of public IPs of all the edge locations.
- Supports HTTP/RTMP protocol (**does not support UDP protocol**)
- In-flight encryption using **HTTPS** (**from client all the way to the origin**)
- To block a specific IP at the CloudFront level, deploy a WAF on CloudFront

## Origin

- **S3 Bucket**
    - For distributing static files
    - **Origin Access Identity (OAl) or Origin Access Control (OAC)** allows the S3 bucket to only be accessed by CloudFront
    - Can be used as ingress to upload files to S3 (transfer acceleration)
- **Custom Origin** (for HTTP) - need to be publicly accessible on HTTP by public IPs of edge locations
    - EC2 Instance
    - ELB
    - S3 Website (may contain client-side script)
    - On-premise backend

<aside>
💡 To restrict access to ELB directly when it is being used as the origin in a CloudFront distribution, create a VPC Security Group for the ELB and use AWS Lambda to automatically update the CloudFront internal service IP addresses when they change.

</aside>

## Pricing

- Price Class All: all regions (best performance)
- Price Class 200: most regions (excludes the most expensive regions)
- Price Class 100: only the least expensive regions