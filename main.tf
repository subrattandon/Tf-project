terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "5.54.1"
    }
  }
}
provider "aws" {
    region = "eu-north-1"
  
}

resource "aws_vpc" "myvpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
      Name = "my-vpc"
    } 
}

resource "aws_subnet" "public" {
    cidr_block = "10.0.1.0/24"
    vpc_id = aws_vpc.myvpc.id
    map_public_ip_on_launch = true
    tags = {
      Name = "pub-subnet"
    }
}

#Internet gateway
resource "aws_internet_gateway" "my-igw" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = "my-igw"
  }
}

#Routing table
resource "aws_route_table" "my-rt" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-igw.id
  }
}

resource "aws_route_table_association" "public-sub" {
  route_table_id = aws_route_table.my-rt.id
  subnet_id      = aws_subnet.public.id
}

resource "aws_subnet" "private" {
    cidr_block = "10.0.2.0/24"
    vpc_id = aws_vpc.myvpc.id
    tags = {
      Name = "prt-subnet"
    }
}

#create EC2 instance with pub-subnet

resource "aws_instance" "myserver" {
    ami = "ami-09278528675a8d54e"
    instance_type = "t3.nano"
    subnet_id = aws_subnet.public.id
    vpc_security_group_ids = [aws_security_group.my_SGs.id]
    associate_public_ip_address = true
    
    #seting up Nginx server in EC2
     user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo amazon-linux-extras enable nginx1
              sudo yum install nginx -y
              sudo systemctl start nginx
              sudo systemctl enable nginx
              EOF

    tags = {
      Name = "Nginx-server"
    }
}

#Enable SGs for HTTP access

resource "aws_security_group" "my_SGs" {
    vpc_id = aws_vpc.myvpc.id

    # INBOUND traffic
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        
 
    }
    

    #OUTBOUND traffic
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"  # (-1 means All protocol i.e. instance se kahi bhi jaa sakte hain)
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      Name = "Nginx-SGs"
    }
}



