provider "aws" {
  region = var.region
}
 
terraform {
  backend "s3" {
    bucket         = "otms-dev-state7864582"
    key            = "env/dev/application/otms/frontend-ec2/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
  }
}
 
# GET SUBNET FROM REMOTE STATE
data "terraform_remote_state" "subnet" {
  backend = "s3"
 
  config = {
    bucket = "otms-dev-state7864582"
    key    = "env/dev/application/network/subnet/terraform.tfstate"
    region = "us-east-1"
  }
}
 
# GET FRONTEND SG FROM REMOTE STATE
data "terraform_remote_state" "frontend_sg" {
  backend = "s3"
 
  config = {
    bucket = "otms-dev-state7864582"
    key    = "env/dev/application/otms/frontend-sg/terraform.tfstate"
    region = "us-east-1"
  }
}
 
# PRIVATE EC2 INSTANCE (No Public IP)
resource "aws_instance" "private_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
 
  # Place in first private subnet (frontend)
  subnet_id = data.terraform_remote_state.subnet.outputs.private_subnet_ids[0]
 
  # Attach Frontend Security Group
  vpc_security_group_ids = [
    data.terraform_remote_state.frontend_sg.outputs.frontend_sg_id
  ]
 
  # SSH Key
  key_name = var.key_name
 
  # No Public IP — access via Bastion or SSM
  associate_public_ip_address = false
 
  tags = {
    Name        = "${var.project}-${var.env}-frontend-instance"
    Environment = var.env
    Project     = var.project
    ManagedBy   = "Terraform"
  }
}
