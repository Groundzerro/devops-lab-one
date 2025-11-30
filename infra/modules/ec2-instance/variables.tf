# infra/modules/ec2-instance/variables.tf

variable "name" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "key_name" {
  type = string
}

variable "security_group_ids" {
  type = list(string)
}

variable "private_ip" {
  description = "Optional fixed private IP"
  type        = string
}

variable "user_data" {
  description = "Optional user_data script content"
  type        = string
  default     = ""
}

variable "tags" {
  type    = map(string)
  default = {}
}
