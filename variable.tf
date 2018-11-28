variable "count" {
    default = 1
  }
variable "bucket" {
    default = "fundappselblogs"
  }
variable "region" {
  description = "AWS region for hosting our your network"
  default = "eu-west-1"
}
variable "public_key_path" {
  description = "Enter the path to the SSH Public Key to add to AWS."
  default = "/home/fundapps/ec2-fundapps.pem"
}
variable "key_name" {
  description = "Key name for SSHing into EC2"
  default = "ec2-fundapps.pem"
}
variable "amis" {
  description = "Base AMI to launch the instances"
  default = {
  ap-south-1 = "ami-xxxxxx"
  }
}
variable "subnets" {
  description = "A list of subnet IDs to attach to the ELB"
  default     = []
}
variable "instanceTenancy" {
 default = "default"
}
variable "enable_dns_hostnames" {
  description = "should be true if you want to use private DNS within the VPC"
  default     = true
}
variable "enable_dns_support" {
  description = "should be true if you want to use private DNS within the VPC"
  default     = true
}
variable "cidr" {
 default = "10.0.0.0/16"
}
variable "public_subnet" {
        default = "10.0.1.0/24"
}
variable "public_subnet1" {
        default = "10.0.2.0/24"
}
variable "private_subnet" {
        default = "10.0.3.0/24"
}
variable "map_public_ip_on_launch" {
        default = true
}
variable "azs" {
  description = "A list of Availability zones in the region"
	default     = ["eu-west-1a", "eu-west-1b"]
}
variable "logging_interval_minutes" {}