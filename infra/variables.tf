# infra/variables.tf

variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-west-2"
}

variable "project_name" {
  description = "Name tag prefix for all resources"
  type        = string
  default     = "devops-lab"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "my_ip_cidr" {
  description = "Your home/office IP in CIDR format for SSH access (e.g. 1.2.3.4/32)"
  type        = string
}

variable "key_name" {
  description = "Name of an existing EC2 Key Pair in this region"
  type        = string
}

variable "base_ami_id" {
  description = "AMI ID for your instances (e.g. Ubuntu 22.04)"
  type        = string
}

variable "instance_type" {
  description = "Default instance type"
  type        = string
  default     = "t3.small"
}
