variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}
 
variable "ami_id" {
  description = "AMI ID for EC2 instance"
  type        = string
  default     = "ami-033bd18826652770f"
}
 
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.small"
}
 
variable "key_name" {
  description = "SSH Key Pair Name"
  type        = string
  default     = "otms-dev-key"
}
 
variable "project" {
  description = "Project name"
  type        = string
  default     = "otms"
}
 
variable "env" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}
