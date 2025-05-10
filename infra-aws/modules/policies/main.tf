data "aws_iam_policy_document" "ec2_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "instance" {
  name               = var.instance_role_name
  assume_role_policy = data.aws_iam_policy_document.ec2_assume.json
}

resource "aws_iam_instance_profile" "ecs" {
  name = var.instance_profile_name
  role = aws_iam_role.instance.name
}

resource "aws_iam_role_policy_attachment" "instance_attach" {
  for_each   = toset(var.instance_managed_policies)
  role       = aws_iam_role.instance.name
  policy_arn = each.key
}

data "aws_iam_policy_document" "task_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "task_execution" {
  name               = var.task_execution_role_name
  assume_role_policy = data.aws_iam_policy_document.task_assume.json
}

resource "aws_iam_role_policy_attachment" "task_attach" {
  for_each   = toset(var.task_execution_managed_policies)
  role       = aws_iam_role.task_execution.name
  policy_arn = each.key
}
