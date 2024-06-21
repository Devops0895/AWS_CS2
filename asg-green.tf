# Creating Launch template for Auto Scaling group

resource "aws_launch_template" "Launch_template_green" {
  count         = length(var.availability_zones)
  name_prefix   = "Launch_template_green"
  image_id      = local.ami
  instance_type = local.instance_type
  key_name      = local.KeyPair
  #user_data = file("data.sh")

  network_interfaces {
    associate_public_ip_address = false
    subnet_id                   = aws_subnet.subnets[count.index].id
    security_groups             = [aws_security_group.application_sg.id]
  }

}

resource "aws_autoscaling_group" "green_asg" {
  count = length(var.availability_zones)
  # no of instances
  desired_capacity = 1
  max_size         = 3
  min_size         = 2

  # Connect to the target group
  target_group_arns = [aws_alb_target_group.green-tg.id]

  vpc_zone_identifier = [ # Creating EC2 instances in private subnet
  aws_subnet.subnets[count.index].id]
  depends_on = [aws_launch_template.Launch_template_green]

  launch_template {
    id      = aws_launch_template.Launch_template_green[count.index].id
    version = "$Latest"
  }

}

resource "aws_autoscaling_attachment" "autoscaling_attachment_green" {
  count                  = length(var.availability_zones)
  autoscaling_group_name = aws_autoscaling_group.green_asg[count.index].id
  lb_target_group_arn    = aws_alb_target_group.green-tg.id
}