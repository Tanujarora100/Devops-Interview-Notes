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