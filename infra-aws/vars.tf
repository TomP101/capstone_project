variable "instance_type" {
  description = "EC2 instance type for ECS hosts"
  type        = string
  default     = "t3.medium"
}

variable "min_size" {
  description = "Minimum number of ECS host instances"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of ECS host instances"
  type        = number
  default     = 3
}

variable "desired_capacity" {
  description = "Desired number of ECS host instances"
  type        = number
  default     = 2
}

variable "tag_name" {
  description = "Name tag for all resources"
  type        = string
  default     = "petclinic"
}
