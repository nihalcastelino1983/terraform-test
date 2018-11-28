variable "count" {
    default = 1
  }
variable "s3bucket" {
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
variable "dnsSupport" {
 default = true
}
variable "dnsHostNames" {
        default = true
}
variable "vpcCIDRblock" {
 default = "10.0.0.0/16"
}
variable "public_subnet" {
        default = "10.0.1.0/24"
}
variable "private_subnet" {
        default = "10.0.2.0/24"
}
variable "mapPublicIP" {
        default = true
}
variable "azs" {
  description = "A list of Availability zones in the region"
	default     = []
}