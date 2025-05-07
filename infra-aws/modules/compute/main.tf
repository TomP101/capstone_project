#Create a temporary VM
resource "aws_instance" "temp_vm" {
  ami                    = var.ami_id
  instance_type          = "t3.micro"
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.instance_sg_ids
  user_data              = file("modules/compute/temp_user_data.sh")
  tags = {
    Name = var.tag_name
  }
}

#Create an image from the temporary vm
resource "aws_ami_from_instance" "vm_image" {
  name               = "vm-image"
  source_instance_id = aws_instance.temp_vm.id
  depends_on         = [aws_instance.temp_vm]
}

#Create instances based on the previously generated image
resource "aws_instance" "ec2" {
  count = 3

  ami                    = aws_ami_from_instance.vm_image.id
  instance_type          = "t3.micro"
  subnet_id              = var.subnet_id
  user_data              = file("modules/compute/user_data.sh")
  vpc_security_group_ids = var.instance_sg_ids
  tags = {
    Name = var.tag_name
  }
  depends_on = [aws_ami_from_instance.vm_image]
}

# Attach created instances to the target group
resource "aws_lb_target_group_attachment" "tg_attach" {
  count            = length(aws_instance.ec2)
  target_group_arn = var.tg_arn
  target_id        = aws_instance.ec2[count.index].id
}
