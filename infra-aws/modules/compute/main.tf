resource "aws_ecs_cluster" "this" {
  name = var.cluster_name
}

data "aws_ami" "ecs" {
  id = data.aws_ssm_parameter.ecs_ami.value
}
resource "aws_launch_template" "ecs" {
  name_prefix   = "${var.cluster_name}-lt-"
  image_id      = var.ami_id
  instance_type = var.instance_type


  iam_instance_profile {
    name = var.instance_profile_name
  }

  vpc_security_group_ids = var.instance_sg_ids
}

resource "aws_autoscaling_group" "ecs" {
  name                      = "${var.cluster_name}-asg"
  launch_template {
    id      = aws_launch_template.ecs.id
    version = "$Latest"
  }
  min_size         = var.min_size
  max_size         = var.max_size
  desired_capacity = var.desired_capacity
  vpc_zone_identifier = var.subnet_ids

}
