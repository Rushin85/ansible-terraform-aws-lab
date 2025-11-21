terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

# -------------------------
# NETWORKING
# -------------------------

resource "aws_vpc" "lab" {
  cidr_block = "10.20.0.0/16"

  tags = {
    Name = "ansible-lab-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.lab.id
  cidr_block              = "10.20.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "ansible-lab-public-subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.lab.id

  tags = {
    Name = "ansible-lab-igw"
  }
}

resource "aws_route_table" "rtb" {
  vpc_id = aws_vpc.lab.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "ansible-lab-rtb"
  }
}

resource "aws_route_table_association" "rtb_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.rtb.id
}

# -------------------------
# SECURITY GROUP
# -------------------------

resource "aws_security_group" "ansible_sg" {
  name        = "ansible-lab-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.lab.id

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ansible-lab-sg"
  }
}

# -------------------------
# AMI
# -------------------------

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# -------------------------
# KEY PAIR
# -------------------------

variable "key_name" {
  description = "Your existing EC2 key pair name"
  type        = string
}

# -------------------------
# EC2 INSTANCES
# -------------------------

resource "aws_instance" "control" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.ansible_sg.id]
  key_name               = var.key_name

  tags = {
    Name = "ansible-control"
  }
}

resource "aws_instance" "node1" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.ansible_sg.id]
  key_name               = var.key_name

  tags = {
    Name = "ansible-node1"
  }
}

# -------------------------
# OUTPUTS
# -------------------------

output "control_public_ip" {
  value = aws_instance.control.public_ip
}

output "node1_private_ip" {
  value = aws_instance.node1.private_ip
}

output "node1_public_ip" {
  value = aws_instance.node1.public_ip
}
