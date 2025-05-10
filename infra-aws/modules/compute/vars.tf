variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for the ECS hosts"
  type        = string
  default     = "t3.medium"
}

variable "instance_profile_name" {
  description = "Name of the IAM instance profile to attach to ECS hosts"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the ECS AutoScalingGroup"
  type        = list(string)
}

variable "instance_sg_ids" {
  description = "List of Security Group IDs for the ECS hosts"
  type        = list(string)
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
  description = "Value for the Name tag on ECS hosts"
  type        = string
}
