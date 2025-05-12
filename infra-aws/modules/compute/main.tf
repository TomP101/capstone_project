resource "aws_ecs_cluster" "this" {
  name = var.cluster_name
}

resource "aws_launch_template" "ecs" {
  name_prefix   = "${var.cluster_name}-lt-"
  image_id      = var.ami_id
  instance_type = var.instance_type

  key_name = var.key_name

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
  cpu                      = "1024"
  memory                   = "2048"

  execution_role_arn = var.execution_role_arn
  task_role_arn      = var.task_role_arn

  volume {
    name      = "db-data"
    host_path = "/ecs/${var.cluster_name}/db-data"
  }

  container_definitions = jsonencode([
    {
      name      = "spring-petclinic"
      image     = "774305577837.dkr.ecr.eu-north-1.amazonaws.com/petclinic:3e8a14d"
      cpu       = 512
      memory    = 1024
      essential = true
      portMappings = [
        { containerPort = 8080, hostPort = 8080, protocol = "tcp" },
        { containerPort = 9404, hostPort = 9404, protocol = "tcp" }
      ]
      environment = [
        { name = "POSTGRES_URL", value = "jdbc:postgresql://db:5432/petclinic" }
      ]
    },
    {
      name      = "db"
      image     = "postgres:latest"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        { containerPort = 5432, hostPort = 5432, protocol = "tcp" }
      ]
      environment = [
        { name = "POSTGRES_DB",       value = "petclinic" },
        { name = "POSTGRES_USER",     value = "petclinic" },
        { name = "POSTGRES_PASSWORD", value = "petclinic" }
      ]
      healthCheck = {
        command     = ["CMD-SHELL","pg_isready -U petclinic"]
        interval    = 10
        timeout     = 5
        retries     = 5
        startPeriod = 0
      }
      mountPoints = [
        {
          sourceVolume  = "db-data"
          containerPath = "/var/lib/postgresql/data"
          readOnly      = false
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "petclinic" {
  name            = "${var.cluster_name}-svc"
  cluster         = aws_ecs_cluster.this.id
  launch_type     = "EC2"
  desired_count   = 1
  task_definition = aws_ecs_task_definition.petclinic.arn

  enable_execute_command = true

  network_configuration {
    subnets         = var.subnet_ids
    security_groups = var.instance_sg_ids
  }

  load_balancer {
    container_name   = "spring-petclinic"
    container_port   = 8080
    target_group_arn = var.target_group_arn
  }

  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
}
