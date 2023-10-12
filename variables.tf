variable "aws_region" {
  description = "enter the region"
  default     = "eu-central-1"
  type        = string
}


variable "instance_type_free" {
  description = "enter the instance_type"
  default     = "t2.micro"
  type        = string
}

variable "instance_type_medium" {
  description = "enter the instance_type"
  default     = "t2.medium"
  type        = string
}


# variable "bastion_ports" {
#   description = "list of ingress ports"
#   default     = ["22"]
#   type        = list(any)
# }

# variable "frontend_ports" {
#   description = "list of ingress ports"
#   port      = 22
# }

# variable "backend_ports" {
#   description = "list of ingress ports"
#   default     = ["22, 8080"]
#   type        = list(any)
# }
