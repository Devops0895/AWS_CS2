data "aws_route53_zone" "selected" {
  name = "testing123.com"
}

# data "aws_availability_zones" "available" {
#   state                  = "available"
#   all_availability_zones = true
# }