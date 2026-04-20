variable "region" {
  default = "us-east-1"
}

variable "ami_id" {
  description = "AMI ID"
}

variable "instance_type" {
  default = "t3.small"
}

variable "key_name" {
  default = "my-terraform-key"
}

variable "project" {
  default = "otms"
}

variable "env" {
  default = "dev"
}
