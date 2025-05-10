variable "instance_role_name" {
  description = "IAM role name for ECS EC2 hosts"
  type        = string
}

variable "instance_profile_name" {
  description = "IAM instance profile name for ECS EC2 hosts"
  type        = string
}

variable "instance_managed_policies" {
  description = "List of managed policy ARNs to attach to the EC2 host role"
  type        = list(string)
  default     = [
    "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
  ]
}

variable "task_execution_role_name" {
  description = "IAM role name for ECS task execution"
  type        = string
}

variable "task_execution_managed_policies" {
  description = "List of managed policy ARNs for ECS task execution role"
  type        = list(string)
  default     = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  ]
}
