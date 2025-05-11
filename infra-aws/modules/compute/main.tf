resource "aws_ecs_cluster" "this" {
  name = var.cluster_name
}

resource "aws_launch_template" "ecs" {
  name_prefix   = "${var.cluster_name}-lt-"
  image_id      = var.ami_id
  instance_type = var.instance_type

  user_data = base64encode(file("${path.module}/user_data.sh"))
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

resource "aws_ecs_task_definition" "petclinic" {
  family                   = "${var.cluster_name}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]
  cpu                      = "512"
  memory                   = "1024"

  container_definitions = jsonencode([
    {
      name      = "petclinic"
      image     = "774305577837.dkr.ecr.eu-north-1.amazonaws.com/petclinic:latest"
      essential = true
      portMappings = [
        { containerPort = 8080, hostPort = 8080, protocol = "tcp" }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${var.cluster_name}"
          awslogs-region        = var.region
          awslogs-stream-prefix = "petclinic"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "petclinic" {
  name            = "${var.cluster_name}-svc"
  cluster         = aws_ecs_cluster.this.id
  launch_type     = "EC2"
  desired_count   = 2
  task_definition = aws_ecs_task_definition.petclinic.arn

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = var.instance_sg_ids
    assign_public_ip = true
  }

  load_balancer {
    container_name   = "petclinic"
    container_port   = 8080
    target_group_arn = var.target_group_arn
  }

  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
}


