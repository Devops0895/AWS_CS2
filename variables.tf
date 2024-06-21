#218453391514

# variable "key_name" {
#   type        = string
#   description = "used to SSH the server"
#   default     = "private"
# }

variable "availability_zones" {
  type = list(string)
  #default = ["us-west-2a", "us-west-2b"] #need to update AZ according to the country
}

variable "subnet_names" {
  type = string
  #default = ["pt-subnet-1"] #should update the name accordingly
  description = "this is for cidr block for instances"
}



variable "instance_names_blue" {
  type    = list(string)
  default = ["Blue-1", "Blue-2"]
}

variable "instance_names_green" {
  type    = list(string)
  default = ["Green-1", "Green-2"]
}

# variable "s3_bucket_name" {
#   description = "Name of the S3 bucket"
#   type        = string
#   #default     = "s3-access-bucket112233"
#   # Add any additional configuration options as needed
# }

variable "region" {
  description = "region which we are working"
  default     = "us-west-2"
}

variable "cloudtrail_name" {
  default     = "ec2-s3-logging-cloud-trail"
  description = "this is for logging the events for ec2 and s3 bucket tasks"
}


# key pair - Location to the SSH Key generate using openssl or ssh-keygen or AWS KeyPair
# variable "ssh_pubkey_file" {
#   description = "Path to an SSH public key"
#   default     = "C:/Users/SaiS2.MUMBAI1/.ssh/id_rsa.pub"
# }


variable "weighted_routing_policy_blue" {
  default     = 30
  description = "This weighted policy is for routing the traffic to blue enviroment"
}


variable "weighted_routing_policy_green" {
  default     = 30
  description = "This weighted policy is for routing the traffic to green enviroment"
}