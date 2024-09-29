• Debugging in Production, the good old way:
• Test locally
• Add log statements everywhere
• Re-deploy in production
• Log formats differ across applications using CloudWatch and analytics is
hard.
• Debugging: monolith “easy”, distributed services “hard”
• No common views of your entire architecture!
![alt text](image.png)
X-Ray compatibility
• AWS Lambda • Elastic Beanstalk • ECS • ELB • API Gateway • EC2 Instances or any application server (even on premise)
AWS X-Ray Leverages Tracing
• Tracing is an end to end way to following a “request”
• Each component dealing with the request adds its own “trace”
• Tracing is made of segments (+ sub segments)
• Annotations can be added to traces to provide extra-information
• Ability to trace:
• Every request
• Sample request (as a % for example or a rate per minute)
• X-Ray Security:
• IAM for authorization
• KMS for encryption at rest
![alt text](image-1.png)
The X-Ray magic
• X-Ray service collects data from all the different services
• Service map is computed from all the segments and traces
• X-Ray is graphical, so even non technical people can help troubleshoot
![alt text](image-2.png)
![alt text](image-3.png)
X-Ray Concepts
• Segments: each application / service will send them
• Subsegments: if you need more details in your segment
• Trace: segments collected together to form an end-to-end trace
• Sampling: decrease the amount of requests sent to X-Ray, reduce cost
• Annotations: Key Value pairs used to index traces and use with filters
• Metadata: Key Value pairs, not indexed, not used for searching
• The X-Ray daemon / agent has a config to send traces cross account:
• make sure the IAM permissions are correct – the agent will assume the role
• This allows to have a central account for all your application tracing
X-Ray Sampling Rules
• With sampling rules, you control the amount of data that you record
• You can modify sampling rules without changing your code
• By default, the X-Ray SDK records the first request each second, and
five percent of any additional requests.
• One request per second is the reservoir, which ensures that at least one
trace is recorded each second as long the service is serving requests.
• Five percent is the rate at which additional requests beyond the
reservoir size are sampled.
![alt text](image-4.png)
X-Ray Write APIs (used by the X-Ray daemon)
• PutTraceSegments: Uploads segment documents to AWS X-Ray
• PutTelemetryRecords: Used by the AWS X-Ray daemon to upload telemetry.
• SegmentsReceivedCount, SegmentsRejectedCounts, BackendConnectionErrors…
• GetSamplingRules: Retrieve all sampling rules (to know what/when to send)
• GetSamplingTargets &
GetSamplingStatisticSummaries: advanced
• The X-Ray daemon needs to have an IAM policy authorizing the correct API calls to
arn:aws:iam::aws:policy/AWSXrayWriteOnlyAccess function correctly
![alt text](image-5.png)
• GetServiceGraph: main graph
• BatchGetTraces: Retrieves a list of
traces specified by ID. Each trace is a
collection of segment documents that
originates from a single request.
• GetTraceSummaries: Retrieves IDs
and annotations for traces available for
a specified time frame using an
optional filter. To get the full traces,
pass the trace IDs to BatchGetTraces.
• GetTraceGraph: Retrieves a service
graph for one or more specific trace
IDs.
![alt text](image-6.png)
![alt text](image-7.png)