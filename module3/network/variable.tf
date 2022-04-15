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
#variable "public_cidr_blocks" {
 # type        = list(string)
  #description = "Public Subnet CIDRs"
#}

# Provision private subnets in custom VPC
#variable "private_cidr_blocks" {
 # type        = list(string)
  #description = "Private Subnet CIDRs"
#}

# VPC CIDR range
#variable "vpc_cidr" {
 # type        = string
  #description = "Prod VPC"
#}

# Variable to signal the current environment 
variable "env" {
  default     = "staging"
  #{["env1" = "staging"
  #"env2" = "prod"]}
  type        = string
  description = "Environment"
}

variable "awsbc" {
  default     = ["us-east-1b","us-east-1c","us-east-1d"]
  type        = list(string)
  description = "AWS regions"
}

# Provision public subnets in custom VPC
variable "public_subnet_cidrs" {
  default     = ["10.200.1.0/24", "10.200.2.0/24", "10.200.3.0/24"]
  type        = list(string)
  description = "Public Subnet CIDRs"
}

# Provision private subnets in custom VPC
variable "private_subnet_cidrs" {
  default     = ["10.200.4.0/24", "10.200.5.0/24", "10.200.6.0/24"]
  type        = list(string)
  description = "Private Subnet CIDRs"
}

# VPC CIDR range
variable "vpc_cidr" {
  default     = "10.200.0.0/16"
  type        = string
  description = "prod VPC"
}