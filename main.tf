terraform {
  backend "s3" {
    bucket         = "otms-dev-state"
    key            = "env/dev/application/otms/private-ec2/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
  }
}

provider "aws" {
  region = var.region
}

# 🔹 Subnet Remote State (PRIVATE SUBNET)
data "terraform_remote_state" "subnet" {
  backend = "s3"

  config = {
    bucket = "otms-dev-state7864582"
    key    = "env/dev/application/network/subnet/terraform.tfstate"
    region = "us-east-1"
  }
}

# 🔹 Security Group Remote State
data "terraform_remote_state" "frontend_sg" {
  backend = "s3"

  config = {
    bucket = "otms-dev-state"
    key    = "env/dev/application/otms/frontend-sg/terraform.tfstate"
    region = "us-east-1"
  }
}

# 🔹 Private EC2 Instance
resource "aws_instance" "private_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type

  # ✅ Private subnet
  subnet_id = data.terraform_remote_state.subnet.outputs.private_subnet_1_id

  # ✅ NO public IP
  associate_public_ip_address = false

  # ✅ Security Group
  vpc_security_group_ids = [
    data.terraform_remote_state.frontend_sg.outputs.security_group_id
  ]

  # ✅ SSH Key (optional)
  key_name = var.key_name

  tags = {
    Name        = "${var.project}-${var.env}-private-ec2"
    Environment = var.env
    Project     = var.project
  }
}
