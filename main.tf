terraform {
  backend "s3" {
    bucket         = "otms-dev-state"
    key            = "env/dev/application/otms/frontend-ec2/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
  }
}

provider "aws" {
  region = var.region
}

# 🔹 Subnet (PRIVATE)
data "terraform_remote_state" "subnet" {
  backend = "s3"

  config = {
    bucket = "otms-dev-state7864582"
    key    = "env/dev/application/network/subnet/terraform.tfstate"
    region = "us-east-1"
  }
}

# 🔹 Security Group
data "terraform_remote_state" "frontend_sg" {
  backend = "s3"

  config = {
    bucket = "otms-dev-state"
    key    = "env/dev/application/otms/frontend-sg/terraform.tfstate"
    region = "us-east-1"
  }
}

# 🔹 PRIVATE EC2 INSTANCE
resource "aws_instance" "private_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type

  # ✅ Private subnet
  subnet_id = data.terraform_remote_state.subnet.outputs.private_subnet_1_id

  # ✅ Attach SG
  vpc_security_group_ids = [
    data.terraform_remote_state.frontend_sg.outputs.security_group_id
  ]

  # ✅ SSH Key
  key_name = var.key_name

  # ❌ NO PUBLIC IP (important)
  associate_public_ip_address = false

  tags = {
    Name        = "${var.project}-${var.env}-private-instance"
    Environment = var.env
    Project     = var.project
  }
}
