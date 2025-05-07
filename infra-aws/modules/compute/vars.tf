variable "subnet_id" {
  description = "subnet ID"
  type        = string
}
variable "ami_id" {
  type    = string
  default = "ami-075449515af5df0d1"
}
variable "tg_arn" {
  description = "the arn of the target group"
  type        = string
}

variable "instance_sg_ids" {
  description = "security group IDs"
  type        = list(string)
}

variable "tag_name" {
  description = "tag for instance"
  type        = string
  default     = "2025_internship_war"
}
