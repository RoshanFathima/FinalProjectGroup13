# Instance type
variable "instance_type" {
  default     = "t3.medium"
  description = "Type of the instance"
  type        = string
}

# Variable to signal the current environment 
variable "env" {
  default     = "prod"
  type        = string
  description = "ProdEnvironment"
}

variable "my_private_ip" {
  type        = string
  default     = "172.31.73.236"
  description = "Private IP of my Cloud 9 station to be opened in bastion ingress"
}

# curl http://169.254.169.254/latest/meta-data/public-ipv4
variable "my_public_ip" {
  type        = string
  default     = "34.204.177.5"
  description = "Public IP of my Cloud 9 station to be opened in bastion ingress"
}

variable "service_ports" {
  type        = list(string)
  default     = ["80", "22"]
  description = "Ports that should be open on a webserver"
}

