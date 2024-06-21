
locals {
  KeyPair                  = "private-key"
  ami                      = "ami-0df5e4502e3d737cf" #ami-089313d40efd067a9
  instance_type            = "t2.small"
  tg_ports                 = 80
  health_check_protocol    = "Http"
  healthcheck_url_path     = "/"
  alb_healthcheck_interval = 10
  unhealthy_threshold      = 2
  healthy_threshold        = 5
  alb_healthcheck_timeout  = 5
  context_path             = ""
}
