resource "aws_vpc" "main" {
cidr_block = "10.0.0.0/16"
tags = {
  name="interview-vpc"
  environment="production"
}
}

resource "aws_subnet" "subnet" {
    vpc_id = aws_vpc.main.id 
    cidr_block = "10.0.0.1/24"
    map_public_ip_on_launch = true
    tags = {
        name="interview-subnet"
        environment="production"
    }
}
resource "aws_internet_gateway" "gateway" {
    vpc_id = aws_vpc.main.id 
    tags={
        Name="my-gateway"
        environment="production"
    }
}
resource "aws_route_table" "public_table" {
    vpc_id = aws_vpc.main.id 
    route = { 
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gateway.id
    }
  
}
resource "aws_route_table_association" "aws_route_table_association" {
    subnet_id = aws_subnet.subnet.id
    route_table_id = aws_route_table.public_table.id
}
resource "aws_security_group" "first-sg" {
    vpc_id = aws_vpc.main.id 
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]

    }
    egress = {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
} 