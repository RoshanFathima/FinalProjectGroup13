# Default tags
variable "default_tags" {
  default     = {}
  type        = map(any)
  description = "Default tags to be appliad to all AWS resources"
}

# Name prefix
variable "prefix" {
  type        = string
  description = "Name prefix"
}

# Provision public subnets in custom VPC
variable "public_cidr_blocks" {
  type        = list(string)
  description = "Public Subnet CIDRs"
}

# Provision private subnets in custom VPC
variable "private_cidr_blocks" {
  type        = list(string)
  description = "Private Subnet CIDRs"
}

# VPC CIDR range
variable "vpc_cidr" {
  type        = string
  description = "Dev VPC"
}

# Variable to signal the current environment 
variable "env" {
  default     = "Dev"
  type        = string
  description = "Dev Environment"
}

variable "awsbc" {
  default     = ["us-east-1b", "us-east-1c", "us-east-ld"]
  type        = list(string)
  description = "AWS regions"
}