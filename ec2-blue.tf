#### This is for blue environment infra

resource "aws_instance" "instances_blue_env" {
  count                  = length(var.instance_names_blue)
  ami                    = local.ami
  instance_type          = local.instance_type
  subnet_id              = aws_subnet.subnets[count.index].id
  vpc_security_group_ids = [aws_security_group.application_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.demo-profile.name
  key_name               = aws_key_pair.generated_key.key_name

  tags = {
    Name = "instance-blue"
  }

  user_data = <<-EOF
    
  sudo yum upgrade -y
  sudo yum update -y
 
  EOF
}
