
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

### RUN ANSIBLE USING TERRAFORM
```bash
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  provisioner "local-exec" {
    command = <<EOT
      ansible-playbook -i '${self.public_ip},' -u ec2-user playbook.yml
    EOT
  }

  tags = {
    Name = "Ansible-Example"
  }
}
```

In Terraform, you can use loops to dynamically create resources, modules, or outputs. Terraform provides two main constructs for looping: `count` and `for_each`. 

### 1. **Using `count`**

The `count` parameter allows you to create multiple instances of a resource.

#### Example: Creating Multiple EC2 Instances

```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "example" {
  count         = 3  # Create 3 instances
  ami           = "ami-12345678"
  instance_type = "t2.micro"

  tags = {
    Name = "Instance-${count.index + 1}"
  }
}
```

In this example, Terraform will create three EC2 instances. The `${count.index}` starts at 0, so `${count.index + 1}` ensures that the instances are named "Instance-1", "Instance-2", and "Instance-3".

### 2. **Using `for_each`**

The `for_each` parameter allows you to loop over a map or a set to create resources. This is more flexible than `count` because it works with named items.

#### Example: Creating Multiple S3 Buckets from a List

```hcl
provider "aws" {
  region = "us-west-2"
}

variable "bucket_names" {
  type    = list(string)
  default = ["bucket-1", "bucket-2", "bucket-3"]
}

resource "aws_s3_bucket" "example" {
  for_each = toset(var.bucket_names)

  bucket = each.value

  tags = {
    Name = each.value
  }
}
```


### 3. **Using `for` Expression in Variables or Outputs**

You can use `for` expressions within variables or outputs to create complex structures.

#### Example: Creating a List of Tags

```hcl
variable "instances" {
  type    = list(string)
  default = ["web", "db", "cache"]
}

output "instance_tags" {
  value = { for inst in var.instances : inst => "${inst}-server" }
}
```

### 4. **Using `for_each` with Maps**

If you have a map and want to create resources with specific values, `for_each` is perfect.

#### Example: Creating Security Groups with Specific Rules

```hcl
provider "aws" {
  region = "us-west-2"
}

variable "security_groups" {
  type = map(object({
    name_prefix = string
    port        = number
  }))

  default = {
    web = {
      name_prefix = "web-sg"
      port        = 80
    }
    db = {
      name_prefix = "db-sg"
      port        = 5432
    }
  }
}

resource "aws_security_group" "example" {
  for_each = var.security_groups

  name        = each.value.name_prefix
  description = "Security group for ${each.key}"

  ingress {
    from_port   = each.value.port
    to_port     = each.value.port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```


### 5. **Using `for_each` with Modules**

You can also loop over a set or map to create multiple instances of a module.

#### Example: Deploying Multiple VPCs Using a Module

```hcl
provider "aws" {
  region = "us-west-2"
}

module "vpc" {
  source = "./modules/vpc"

  for_each = {
    prod = "10.0.0.0/16"
    dev  = "10.1.0.0/16"
  }

  vpc_name = each.key
  cidr     = each.value
}
```