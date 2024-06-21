
resource "aws_iam_instance_profile" "demo-profile" {
  name = "demo_profile"
  #role = aws_iam_role.s3_cw_access_role.name
}

resource "tls_private_key" "private" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name = local.KeyPair
  #public_key = file("~/.ssh/private-key.pub")
  public_key = "Need to be updated with local public key"
}