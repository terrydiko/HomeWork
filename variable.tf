variable "Instance_type" {
  type        = string
  description = "instance type for ec2 instance "
  default     = "t2.micro"

}

variable "key_name" {
  type        = string
  description = "key name for instances"
  default     = "CamNova"

}

variable "ami" {
  type        = string
  description = "ami for instances"
  default     = "ami-04ad2567c9e3d7893"

}
