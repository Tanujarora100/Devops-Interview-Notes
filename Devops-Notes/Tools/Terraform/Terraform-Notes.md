#### Feature of Terraform
- Declarative in nature
  - Match Current and Desired State of the state file.
- HCL and JSON supported 
- Developed by Hashicorp
- Idempotent in nature.

#### Flow of Terraform
- Terraform init 
- Terraform validate
- Terraform plan 
- Terraform apply 
- Terraform destroy

#### How does Terraform manage dependencies?
- Terraform uses a dependency graph to manage dependencies between resources.

``` hcl
resource "aws_instance" "web" {
ami = "ami-0c55b159cbfafe1f0"
instance_type = "t2.micro"
subnet_id = aws_subnet.example.id
}
resource "aws_subnet" "example" {
vpc_id = aws_vpc.example.id
cidr_block = "10.0.1.0/24"
}
resource "aws_vpc" "example" {
cidr_block = "10.0.0.0/16"
}
```
#### Create ASG In Terraform
```h
resource "aws_autoscaling_group" "example" {
  name                 = "example-asg"
  min_size             = 2
  max_size             = 5
  desired_capacity     = 2
  vpc_zone_identifier  = ["${aws_subnet.example.id}"]

  target_group_arns = ["${aws_lb_target_group.example.arn}"]
}
```
#### What is the purpose of the terraform_remote_state data source and how is it used?
- The terraform_remote_state data source in Terraform enables sharing and retrieving outputs from a separate Terraform state file. 

```hcl
data "terraform_remote_state" "networking" {
 backend = "s3"
  config = {
     bucket = "example-bucket"
     key = "networking.tfstate"
     region = "us-west-2"
   }
}

resource "aws_instance" "example" {
 // Use the remote state output as input for resource configuration
 subnet_id = data.terraform_remote_state.networking.outputs.subnet_id
 // …
}
```


#### What is a state file in Terraform?
- A state file is a file that Terraform uses to keep track of the current state of the infrastructure. 
- It maps the resources defined in the configuration to the real-world resources.

#### How can you secure the state file in Terraform?
- Remote Backends
- Server side encryption
- Versioning on S3 Bucket
```hcl
terraform {
backend "s3" {
bucket = "my-terraform-state"
key = "global/s3/terraform.tfstate"
region = "us-west-2"
encrypt = true
}
}
```
#### What is the purpose of the terraform init command?
- Terraform init initializes a working directory containing Terraform configuration files,
downloads the necessary provider plugins.

#### How can we export data from one module to another?
- In Terraform, you can export data from one module to another by using **outputs**.
- Whatever you need to export to another module just make a output out of it 
```h
output "example_output" {
  value = <value_to_export>
}
```
- In the target module just mention the source as the module name and path to it.
- use the output from that module such as VPC_ID, Subnet_ID
```h
module "example_module" {
  source = "./path/to/module"
  example_input = module.module_name.example_output
}
```


#### What does the terraform plan command do?
- Terraform plan creates an execution plan, showing what actions Terraform will take to achieve the desired state.

#### What is Terraform’s “target” argument and how can it be useful?
- The “target” argument in Terraform allows you to specify a single resource or module to be targeted for an operation.
```h
terraform apply -target="aws_security_group.my_sg"
```

#### What is the terraform apply command used for?
- Terraform apply applies the changes required to reach the desired state of the configuration.
- Here the terraform state file is created.

#### How do you define and use variables in Terraform?
```
variable "instance_type" {
description = "Type of EC2 instance"
default = "t2.micro"
}
resource "aws_instance" "example" {
ami = "ami-0c55b159cbfafe1f0"
instance_type = var.instance_type
}
```
#### How do you import existing resources into Terraform?
-  terraform import command
```
terraform import aws_instance.example i-1234567890abcdef0
```
#### What are provisioners in Terraform?
- execute scripts or commands on a local or remote machine as part 
```
resource "aws_instance" "example" {
ami = "ami-0c55b159cbfafe1f0"
instance_type = "t2.micro"
provisioner "local-exec" {
command = "echo ${self.public_ip} > ip_address.txt"
}
}
```
#### How do you use conditional expressions in Terraform?
- Conditional expressions in Terraform are used to assign values based on conditions using the
ternary operator condition ? true_value : false_value.
```
variable "environment" {
default = "dev"
}
resource "aws_instance" "example" {
ami = "ami-0c55b159cbfafe1f0"
instance_type = var.environment == "prod" ? "t2.large" : "t2.micro"
}
```
#### What is the terraform destroy command used for?
- Terraform destroy is used to destroy the infrastructure managed by Terraform.

#### How do you handle provider dependencies in Terraform?
- Make a providers.tf
- `required_providers` block in
the terraform block, specifying the version constraints.
```
terraform {
required_providers {
aws = {
source = "hashicorp/aws"
version = "~> 3.0"
}
}}
```

#### What are locals in Terraform and how do you use them?
- Locals in Terraform are used to define local values that can be reused within a module. 
```
locals {
instance_type = "t2.micro"
ami_id = "ami-0c55b159cbfafe1f0"
}
resource "aws_instance" "example" {
ami = local.ami_id
instance_type = local.instance_type
}
```
#### What is the terraform console command used for?
- Terraform console opens an interactive console for evaluating expressions, testing.

#### How do you use a lock file in Terraform?
- A lock file (.terraform.lock.hcl) is used to lock provider versions
- ensuring consistency in provider versions.

```hcl
provider "registry.terraform.io/hashicorp/aws" {
  version = "3.40.0"
  constraints = "~> 3.0"
  hashes = [
    "h1:EOJImaEaVThWasdqnJjfYc6/P8N/MRAq1J7avx5ZbV4=",
    "zh:0015b491cf9151235e57e35ea6b89381098e61bd923f56dffc86026d58748880",
  ]
}
```



#### What is a count parameter in Terraform?
- The count parameter in Terraform is used to create multiple instances of a resource based on a
specified number.
```
resource "aws_instance" "example" {
count = 3
ami = "ami-0c55b159cbfafe1f0"
instance_type = "t2.micro"
}
```
#### How do you use loops in Terraform?
- Loops in Terraform can be implemented using the count and for_each meta-arguments, as
well as the for expression in variable assignments.
```
variable "instance_names" {
type = list(string)
default = ["instance1"
,
"instance2"]
}
resource "aws_instance" "example" {
for_each = toset(var.instance_names)
ami = "ami-0c55b159cbfafe1f0"
instance_type = "t2.micro"
tags = {
Name = each.key
}
}
```
#### COUNT VS FOR-EACH
- Count is used to create multiple instances of a resource, while for_each is used to iterate over a
map or set of values to create multiple instances.
```
resource "aws_instance" "example" {
count = 3
ami = "ami-0c55b159cbfafe1f0"
instance_type = "t2.micro"
}
```
```
resource "aws_instance" "example" {
for_each = toset(["instance1"
,
"instance2"])
ami = "ami-0c55b159cbfafe1f0"
instance_type = "t2.micro"
tags = {
Name = each.key
}
}
```
#### What is the difference between terraform output and output values in configuration?
- Terraform output is a command that displays the output values of a Terraform configuration,
**while output values in configuration are defined using the output block**.
```
output "instance_id" {
value = aws_instance.my_ec2.id
}
```
#### WHAT IS LIFECYCLE BLOCK?
In Terraform, the `lifecycle` block is a powerful meta-argument that allows you to control how resources are created, updated, and destroyed. 

### **Lifecycle Meta-Arguments**

### **1. `create_before_destroy`**

- **Type**: Boolean
- **Description**:new resource is created before the existing one is destroyed. It is particularly useful for minimizing downtime when replacing resources that cannot be updated in place.
- **Usage**:
  ```hcl
  resource "aws_instance" "example" {
    ami           = "ami-0c55b159cbfafe1f0"
    instance_type = "t2.micro"

    lifecycle {
      create_before_destroy = true
    }
  }
  ```

### **2. `prevent_destroy`**

- **Type**: Boolean
- **Description**: If a plan includes the destruction of a resource with `prevent_destroy` set to `true`, Terraform will produce an error.
- **Usage**:
  ```hcl
  resource "aws_instance" "example" {
    ami           = "ami-0c55b159cbfafe1f0"
    instance_type = "t2.micro"

    lifecycle {
      prevent_destroy = true
    }
  }
  ```
- **Considerations**: This is useful for protecting critical resources from accidental deletion

### **3. `ignore_changes`**

- **Type**: List of attribute names
- **Description**: Instructs Terraform to ignore changes to specified attributes of a resource. This is useful when certain attributes are managed outside of Terraform or should not trigger updates.
- **Usage**:
  ```hcl
  resource "aws_instance" "example" {
    ami           = "ami-0c55b159cbfafe1f0"
    instance_type = "t2.micro"

    lifecycle {
      ignore_changes = [
        tags,
      ]
    }
  }
  ```
- **Special Keyword**: The keyword `all` can be used to ignore all attributes, meaning Terraform will only create and destroy the resource but never update it.
  ```hcl
  lifecycle {
    ignore_changes = all
  }
  ```¯

### **4. `replace_triggered_by`**

- **Type**: List of attribute names or resource addresses
- **Description**: Specifies conditions that should trigger the replacement of the resource. This can be based on changes to specific attributes or other resources.
- **Usage**:
  ```hcl
  resource "aws_instance" "example" {
    ami           = "ami-0c55b159cbfafe1f0"
    instance_type = "t2.micro"

    lifecycle {
      replace_triggered_by = [
        "aws_vpc.example.id",
        "aws_subnet.example.id"
      ]
    }
  }
  ```
- **Considerations**: This is useful for complex dependencies where changes to related resources should trigger the replacement of the current resource

### **5. `precondition` and `postcondition`**

- **Type**: Blocks with condition and error_message
- **Description**: These arguments allow you to define custom checks before and after resource actions. If the condition is not met, Terraform will produce an error with the specified message.
- **Usage**:
  ```hcl
  resource "aws_instance" "example" {
    ami           = "ami-0c55b159cbfafe1f0"
    instance_type = "t2.micro"

    lifecycle {
      precondition {
        condition     = "${var.some_condition}"
        error_message = "Precondition failed: some_condition must be true"
      }

      postcondition {
        condition     = "${self.some_attribute == var.expected_value}"
        error_message = "Postcondition failed: some_attribute must match expected_value"
      }
    }
  }
  ```
#### Types of Providers in terraform
- Official Providers: 
- Verified Providers:
- Community Providers: Developed by individuals or group.

#### How to manage Multiple Environments
- Separate directory
- Terraform workspaces
- Terraform workspace select <workspace name>
- Different Backends
- Prod.tfvars, staging.tfvars

#### How to handle sensitive data
- Env variables
- Encrypted files and decrypt them at run time
- Sensitive variables by marking as sensitive= true

```
Variable “db_prod_password”{
type=string
sensitive=true
}
```
#### How to handle dependency management
- Implicit Dependencies
Implicit dependencies are automatically detected by Terrafor
VPC and Subnet
```h
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}


resource "aws_subnet" "example" {
  vpc_id     = aws_vpc.example.id
  cidr_block = "10.0.1.0/24"
}
```
#### Explicit Depedency:
Depends_on argument
```h
resource "aws_s3_bucket" "example" {
  bucket = "my-bucket"
}


resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  depends_on    = [aws_s3_bucket.example]
}
```
#### Best Practices for dependency Mnaagement:
- Favor Implicit Dependencies: Use implicit dependencies whenever possible, as they are automatically managed
- Use Explicit Dependencies Sparingly: Explicit dependencies should be used only when necessary,
- Document Dependencies: Always document the reasons for explicit dependencies

#### Handling State Drift
- State drift occurs when the real-world infrastructure diverges from the state file. 
- Regularly reconciling state drift by using the **terraform refresh command** or importing resources 
-  `terraform refresh` command is deprecated now use `terraform apply -refresh-only` instead
- Terraform provides commands like `terraform state rm`.

#### Migrate Local Config to remote backend
- Configure the backend
```
Terraform {
Backend{
bucket=”my_terraform_state_bucket”
key=”path”
region=”us-west-1”
dynamodb_table=”terraform_state_db”
}}
```
- Do terraform init promt will come
### Local_exec and remote_exec
Local Exec:
The local-exec provisioner runs a command locally on the machine where Terraform is being executed.
resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"


  provisioner "local-exec" {
    command = "echo ${self.private_ip} >> private_ips.txt"
  }
}


#### Remote-Exec Provisioner

```
resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"


  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("./path/to/private_key.pem")
    host        = self.public_ip
  }


  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx"
    ]
  }
}
```
#### DynamoDB Concurrency Control for Terraform Remote Backend
- DynamoDB uses an **optimistic locking mechanism**
    - Two Writes together is not taken
    - **Version Attribute**: Each item in the DynamoDB table has a version attribute. 
    - When an item is read, its version number is also retrieved. 
    - Before updating the item, the client checks that the version number has not changed. 
    - If the version matches, the update proceeds, and the version number is incremented. If the version does not match, the update is rejected, and a **`ConditionalCheckFailedException`** is thrown.


- **LockID**: The DynamoDB table used for state locking has a primary key, typically named **`LockID`**, which uniquely identifies the lock. 
  - When Terraform needs to perform an operation that modifies the state, it attempts to acquire a lock by writing a new item with a unique **`LockID`**, **At each time only one process can acquire the lock**


### **Configuration Example**

Here is an example of how to configure Terraform to use an S3 backend with DynamoDB for state locking:

```hcl
terraform {
  backend "s3" {
    bucket         = "myorg-terraform-states"
    key            = "myapp/production/tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
  }
}
```


## **Terraform Taint**

### **Purpose**
The `terraform taint` command is used to manually mark a resource as tainted, indicating that it needs to be destroyed and recreated during the next `terraform apply` operation. 

### **Usage**
- **Command**: `terraform taint [options] <address>`
- **Example**: `terraform taint aws_instance.example`

- **Deprecation**: 
- The recommended approach is to use the `-replace` option with `terraform apply` (e.g., `terraform apply -replace="aws_instance.example"`).

### **Use Cases**
- **Failed Provisioning**: When a resource is created but fails during provisioning, marking it as tainted ensures it will be recreated.
- **Manual Changes**: If manual changes were made to a resource outside of Terraform, tainting it can force a clean state by recreating the resource.


## **Comparison Table**

| Feature                 | `terraform taint`                           | `terraform import`                       |
|-------------------------|---------------------------------------------|------------------------------------------|
| **Purpose**             | Mark resource for destruction and recreation| Import existing resource into state      |
| **Usage Example**       | `terraform taint aws_instance.example`      | `terraform import aws_instance.example i-abcd1234` |
| **State Modification**  | Marks resource as tainted                   | Adds resource to state                   |
| **Immediate Changes**   | No                                          | No                                       |
| **Configuration Impact**| Requires no change in configuration         | Requires writing configuration manually  |
| **Deprecation**         | Deprecated in v0.15.2, use `-replace`       | Not deprecated                           |
| **Typical Use Cases**   | Failed provisioning, manual changes         | Legacy resources, state recovery         |


## **Steps to Ensure Secure and Compliant Terraform Configurations**
- **Implement Least Privilege Access**:
- **Store State Remotely and Securely**:
- **Avoid Storing Secrets in State**: AWS Secrets Manager, HashiCorp Vault, or encrypted files[6].
- **Use Static Analysis Tools**:
- Implement tools like `terraform validate`, `TFLint.
- **Continuous Monitoring and Drift Detection**: Implement drift detection tools like `driftctl` to monitor for changes

#### What is the "Random" provider? What is it used for

- The random provider aids in generating numeric or alphabetic characters to use as a prefix or suffix for a desired named identifier.

## **Null Resource**
A **null resource** in Terraform is a resource that does not manage any real infrastructure but can be used to execute provisioners or other actions that are not tied to a specific resource. 
- This can be useful for running scripts, commands, or other operations that need to be part of your Terraform workflow.

### **Example Usage**

```hcl
resource "null_resource" "example" {
  provisioner "local-exec" {
    command = "echo Hello world"
  }
}
```
## **Dynamic Blocks**
**Dynamic blocks** in Terraform allow you to programmatically generate nested blocks within a resource, data source, provider, or provisioner. 
- This is particularly useful for reducing redundancy and managing complex configurations where multiple similar blocks are needed.

### **Example Usage**

```hcl
variable "settings" {
  type = list(object({
    description = string
    port        = number
  }))
  default = [
    { description = "Allows SSH access", port = 22 },
    { description = "Allows HTTP traffic", port = 80 },
    { description = "Allows HTTPS traffic", port = 443 }
  ]
}

resource "aws_security_group" "sandbox_sg" {
  name   = "sandbox_sg"
  vpc_id = aws_vpc.sandbox_vpc.id

  dynamic "ingress" {
    for_each = var.settings
    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}
```

## **Data Sources**

**Data sources** in Terraform allow you to fetch data from external sources or existing infrastructure. 
- This data can then be used to configure other resources within your Terraform configuration. 
- Data sources are read-only and do not create or manage infrastructure but provide information that can be used dynamically.

### **Example Usage**

```hcl
data "aws_ami" "example" {
  most_recent = true
  owners      = ["self"]
  filters = {
    Name   = "app-server"
    Tested = "true"
  }
}

resource "aws_instance" "example" {
  ami           = data.aws_ami.example.id
  instance_type = "t2.micro"
}
```
## **Combining Concepts**

### **Example Usage**

```hcl
data "aws_instances" "all" {
  filter {
    name   = "instance-state-name"
    values = ["running"]
  }
}

resource "null_resource" "example" {
  count = length(data.aws_instances.all.ids)

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/id_rsa")
      host        = element(data.aws_instances.all.public_ips, count.index)
    }

    inline = [
      "echo 'Hello from remote host'",
      "mkdir -p /path/to/remote/directory"
    ]
  }
}
```
### You want to know from which paths Terraform is loading providers referenced in your Terraform configuration (*.tf files). You need to enable debug messages to find this out. Which of the following would achieve this?
- Set the environment variable TF_LOG=TRACE

## **Variables Declaration vs. Assignment**

### **variables.tf**
- **Purpose:** The `variables.tf` file is used to declare variables. This includes specifying the variable names, types, and optionally, default values and descriptions.
- **Example:**
  ```hcl
  variable "instance_type" {
    type        = string
    default     = "t2.micro"
    description = "Type of instance to be created"
  }
  ```
- **Function:** This file tells Terraform what variables are available for use in the configuration and what types of values they can accept. It does not assign specific values to these variables.

### **terraform.tfvars**
- **Purpose:** The `terraform.tfvars` file is used to assign values to the variables declared in `variables.tf`.
- **Example:**
  ```hcl
  instance_type = "t2.large"
  ```
- **Function:** This file provides the actual values that Terraform will use when executing plans and applies. It overrides any default values specified in `variables.tf`.

## **Why Both Files are Needed**

### **Separation of Concerns**
- **variables.tf:** This file focuses on defining the structure and constraints of the variables. It ensures that all variables are declared in one place, making the configuration more readable and maintainable.
- **terraform.tfvars:** This file is used to provide specific values for those variables, which can vary between different environments (e.g., development, staging, production).

### **Flexibility and Reusability**

- **Flexibility:** You can have multiple `.tfvars` files (e.g., `dev.tfvars`, `prod.tfvars`) and specify which one to use with the `-var-file` flag when running Terraform commands:
  ```sh
  terraform plan -var-file="prod.tfvars"
  ```

### **Auto-loading**
- Terraform automatically loads files named `terraform.tfvars` or ending in `.auto.tfvars`

## **Example Workflow**

1. **Declare Variables in `variables.tf`:**
   ```hcl
   variable "instance_type" {
     type        = string
     default     = "t2.micro"
     description = "Type of instance to be created"
   }
   ```

2. **Assign Values in `terraform.tfvars`:**
   ```hcl
   instance_type = "t2.large"
   ```

3. **Run Terraform Commands:**
   ```sh
   terraform plan
   terraform apply
   ```
   ```sh
   terraform plan -var-file="dev.tfvars"
   ```
#### Question: When you created the environment using Terraform, what components did you create using Terraform?

Answer: I created ec2 instances, s3 buckets, network security groups, application gateways

#### Question: How can you make changes in the configuration of already created resources using Terraform?
- To make changes in the configuration of already created resources, we can use the terraform import command.
- Second is make changes in the configuration and run terraform apply again, terraform refresh is also there to check drifting.

#### Question: In case the state file is lost, how do you resolve that issue?
- If the state file is lost, using the terraform import command can help. 
### Question: What are the major features of Terraform that you find noteworthy?
- Multi Cloud
- Easy to use
- Multiple providers
- Awesome documentaton.
#### Question: What is the full form of HCL?
Answer: HCL stands for HashiCorp Configuration Language.

#### What is the lifecycle block in Terraform?

Answer: The lifecycle block is a nested block within a resource block, containing meta-arguments for resource behavior, such as create_before_destroy, prevent_destroy, and others.

#### Question: Is it possible to destroy a single resource out of multiple resources using Terraform?
Answer: Yes, it is possible. We can use the terraform destroy -target command followed by the resource type

### Question: How do you preserve keys created using Terraform?
- Keys created using Terraform can be preserved by storing them in the AWS CLI configuration folder under the credentials directory and instructing Terraform to use a specific profile during execution.

#### Question: What happens if the Terraform state file is accidentally deleted?
- If the Terraform state file is deleted, Terraform may duplicate all resources, leading to increased costs and potential issues with overlapping and cross-pollination between resources.

#### Question: Have you worked with Terraform modules?
Answer: Yes, I have worked with Terraform modules. 
- There are root modules, child modules, and published modules in Terraform.

#### Question: How do you manage Terraform code in multiple environments?
- Answer: Terraform workspaces and reusable modules can be used to manage Terraform code in multiple environments, allowing separate state files for each workspace.

#### Question: What is Terraform workspace used for?
- Answer: Terraform workspace allows managing separate state files for each workspace, enabling different environment processing.

#### Question: How do you provide variable values at runtime in Terraform?
- To provide variable values at runtime in Terraform, the default values in the variable file (variable.tf) can be removed, and the values can be provided when running the Terraform command.
- To provide variable values at runtime in Terraform, you can use several methods, including command-line flags, variable definition files (`.tfvars`), and environment variables.

### 1. Command-Line Flags
You can pass variable values directly when running Terraform commands using the `-var` flag. This method is useful for quick overrides or when dealing with a small number of variables.

#### Example Command

```bash
terraform apply -var="ami=ami-123456" -var="instance_type=t2.micro"
```
### 2. Variable Definition Files (`.tfvars`)
 These files typically have the `.tfvars` extension and contain key-value pairs for your variables.

#### Example `variables.tf`

```hcl
variable "ami" {
  description = "The AMI ID"
  type        = string
}

variable "instance_type" {
  description = "The instance type"
  type        = string
}
```

#### Example `terraform.tfvars`

```hcl
ami = "ami-123456"
instance_type = "t2.micro"
```
```bash
terraform apply -var-file="terraform.tfvars"
```
### 3. Environment Variables
Terraform also supports setting variable values through environment variables. The environment variable must be prefixed with `TF_VAR_` followed by the variable name.

#### Example Environment Variables

```bash
export TF_VAR_ami="ami-123456"
export TF_VAR_instance_type="t2.micro"
```
 environment variables to set the corresponding values.
#### Question: Can you mention some drawbacks of Terraform based on your experience?
- lack of error handling
- restriction to (HCL)
- limitations on importing certain things.

## Functions in Terraform
1. **String Functions**
2. **Numeric Functions**
3. **Collection Functions**
4. **Date and Time Functions**
5. **Crypto and Hash Functions**

### Commonly Used Functions

#### String Functions

- **`format`**: Formats a string with placeholders for variables.
  ```hcl
  format("Hello, %s!", "Terraform")
  ```

- **`join`**: Joins a list of strings into a single string.
  ```hcl
  join(", ", ["a", "b", "c"])
  ```
## Data Sources in Terraform

- Data sources in Terraform allow you to query and use information defined outside of your Terraform configuration.
- Data sources are read-only and do not create or modify resource

### Key Concepts

1. **Data Resource**: A special kind of resource used to query information. Declared using a `data` block.
2. **Managed Resource**: Resources that Terraform creates, updates, or deletes.
3. **Meta-Arguments**: Arguments that apply across all data sources and managed resources, such as `depends_on`.

### Using Data Sources

A data source is accessed via a `data` block.

```hcl
data "aws_ami" "example" {
  most_recent = true
  owners      = ["self"]
  tags = {
    Name   = "app-server"
    Tested = "true"
  }
}
```

### Local-Only Data Sources

Some data sources operate only within Terraform itself and do not interact with external systems. Examples include rendering templates, reading local files, and generating AWS IAM policies.

3. **Using External Data Source**:

    ```hcl
    data "external" "example" {
      program = ["python3", "${path.module}/scripts/fetch_data.py"]

      query = {
        key = "value"
      }
    }

    output "external_data" {
      value = data.external.example.result
    }
    ```

### Benefits of Using Data Sources

- **Dynamic Configuration**:
- **Reusability**:
- **Flexibility**:

### Common Mistakes to Avoid

- **Referencing Nonexistent Data**:
- **Circular Dependencies**: Avoid creating circular dependencies between data sources and managed resources.

### External Data Block in Terraform

The external data source in Terraform allows you to integrate external programs and scripts into your Terraform configuration.

#### Key Concepts
- **External Program**: An external script or program that Terraform calls to fetch data.
- **Result**: The output from the external program, which must be in JSON format.

#### How It Works

1. **Define the External Data Source**: Use the `data "external"` block to specify the external program and its input parameters.
2. **Process the Output**: The program must return its output in JSON format via standard output (stdout). 
#### Example Usage
1. **Create an External Script**:For example, a Python script `example-data-source.py`:

    ```python
    import json
    import sys

    # Read the JSON input from stdin
    input_data = json.load(sys.stdin)

    # Process the input data and generate output
    result = {
        "output_key": "output_value",
        "input_received": input_data["example_key"]
    }

    # Print the result as JSON
    print(json.dumps(result))
    ```

2. **Define the External Data Source in Terraform**:

    ```hcl
    data "external" "example" {
      program = ["python", "${path.module}/example-data-source.py"]

      query = {
        example_key = "example_value"
      }
    }

    output "external_output" {
      value = data.external.example.result.output_key
    }

    output "input_received" {
      value = data.external.example.result.input_received
    }
    ```


#### Common Issues and Troubleshooting

- **Invalid JSON Output**: Ensure the external program outputs valid JSON. 
- **Authentication and Permissions**: Ensure the external program has the necessary permissions.

### Multiple People Working In Same Directory But Different Infrastructure
- Using Terraform Workspaces
- Each workspace has its own state data, which allows you to create and manage different sets of infrastructure
