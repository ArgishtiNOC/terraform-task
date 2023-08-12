provider "aws" {
    region = "us-east-1" 
} 

resource "aws_vpc" "task4" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "task4"
  }
}

resource "aws_subnet" "task4-public-1"{
    vpc_id = aws_vpc.task4.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"
}

resource "aws_subnet" "task4-public-2"{
    vpc_id = aws_vpc.task4.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1b"
}

resource "aws_route_table" "route-table-task4"{
    vpc_id = aws_vpc.task4.id

    route {
        cidr_block= "0.0.0.0/0"
        gateway_id=aws_internet_gateway.task4-igw.id
    }
}

resource "aws_internet_gateway" "task4-igw"{
    vpc_id = aws_vpc.task4.id 
}

resource "aws_route_table_association" "subnet1_association" {
  subnet_id      = aws_subnet.task4-public-1.id
  route_table_id = aws_route_table.route-table-task4.id
}

resource "aws_route_table_association" "subnet2_association" {
  subnet_id      = aws_subnet.task4-public-2.id
  route_table_id = aws_route_table.route-table-task4.id
}

