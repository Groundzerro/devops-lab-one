# infra/modules/security-group/variables.tf

variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "ingress_cidrs" {
  description = "List of CIDR blocks to allow in"
  type        = list(string)
}

variable "ingress_ports" {
  description = "List of ports to allow in (TCP)"
  type        = list(number)
}

variable "tags" {
  description = "Tags to apply to the security group"
  type        = map(string)
  default     = {}
}
