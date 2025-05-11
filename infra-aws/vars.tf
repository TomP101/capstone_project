variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-north-1"
}

variable "instance_type" {
  description = "EC2 instance type for ECS hosts"
  type        = string
  default     = "t4g.medium"
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


variable "key_name" {
  description = "The name of the EC2 Key Pair to use for SSH access"
  type        = string
}