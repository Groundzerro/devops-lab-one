# infra/modules/network/variables.tf

variable "vpc_cidr_block" {
  type = string
}

variable "public_subnet_cidr" {
  type = string
}

variable "project_name" {
  type = string
}
