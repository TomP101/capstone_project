#Create a vpc used by the resources
resource "aws_vpc" "network" {
  cidr_block = "10.0.0.0/24"
  tags = {
    Name = var.tag_name
  }
}

#Create two subnets in diffrent availability zone to provice high availability
resource "aws_subnet" "subnet_eu_north1a" {
  vpc_id                  = aws_vpc.network.id
  availability_zone       = "eu-north-1a"
  map_public_ip_on_launch = true
  cidr_block              = "10.0.0.0/25"
  tags = {
    Name = var.tag_name
  }
}
resource "aws_subnet" "subnet_eu_north1b" {
  vpc_id                  = aws_vpc.network.id
  availability_zone       = "eu-north-1b"
  map_public_ip_on_launch = true
  cidr_block              = "10.0.0.128/25"
  tags = {
    Name = var.tag_name
  }
}

#Create a security group that also acts as a virtual firewall for the instances and the loadbalancer
resource "aws_security_group" "sg1" {
  vpc_id = aws_vpc.network.id
  ingress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Create an internet gateway to enable traffic over the internet
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.network.id
  tags = {
    Name = var.tag_name
  }
}

#Create routes thgrough the igw to enable traffic over the internet
resource "aws_route_table" "routetable" {
  vpc_id = aws_vpc.network.id
  tags = {
    Name = var.tag_name
  }
}
resource "aws_route_table_association" "sub_eu_north1a_asso" {
  route_table_id = aws_route_table.routetable.id
  subnet_id      = aws_subnet.subnet_eu_north1a.id
}
resource "aws_route_table_association" "sub_eu_north1b_asso" {
  route_table_id = aws_route_table.routetable.id
  subnet_id      = aws_subnet.subnet_eu_north1b.id
}
resource "aws_route" "internet_route" {
  route_table_id         = aws_route_table.routetable.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

#Create the application load balancer 
resource "aws_lb" "application-lb" {
  name               = "aws-alb"
  internal           = false
  ip_address_type    = "ipv4"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg1.id]
  subnets            = [aws_subnet.subnet_eu_north1a.id, aws_subnet.subnet_eu_north1b.id]
  tags = {
    Name = var.tag_name
  }
}

#Define and create the target group for the load balancer with a health check
resource "aws_lb_target_group" "tg_ec2" {
  health_check {
    interval            = "10"
    path                = "/"
    protocol            = "HTTP"
    timeout             = "5"
    healthy_threshold   = "5"
    unhealthy_threshold = "2"
  }
  name        = "target-group"
  port        = "80"
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.network.id
}

#Create a listener for the load balancer that forwards the traffic to the instances in the target group
resource "aws_lb_listener" "listener_forward_all" {
  load_balancer_arn = aws_lb.application-lb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.tg_ec2.arn
    type             = "forward"
  }
}
