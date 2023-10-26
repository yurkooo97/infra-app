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

variable "health_check" {
  type = map(string)
  default = {
    "timeout"             = "5"
    "interval"            = "30"
    "path"                = "/"
    "port"                = "80"
    "unhealthy_threshold" = "5"
    "healthy_threshold"   = "2"
  }
}

variable "rds_username" {
  description = "enter the rds_username"
  default     = ""
  type        = string
}

variable "rds_password" {
  description = "enter the rds_password"
  default     = ""
  type        = string
}
