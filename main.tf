provider "aws" {
  access_key = "aws_access_key_id"
  secret_key = "aws_secret_access_key_id"
  region     = "eu-west-1"
}
### Creating Security Group for EC2
resource "aws_security_group" "instance" {
  name = "terraform-fundapps-instance"
  vpc_id = "${aws_vpc.fundapps.id}"
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
## Security Group for ELB
resource "aws_security_group" "elb" {
  name = "terraform-fundapps-elb"
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["10.0.0.0/16"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
### Creating ELB
resource "aws_elb" "fundapps" {
  name = "terraform-asg-fundapps"
  security_groups = ["${aws_security_group.elb.id}"]
  availability_zones = ["${var.azs}"]
  access_logs {
    bucket        = "${var.bucket}"
    interval      = "${var.logging_interval_minutes}"
  }
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:8080/"
  }
  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = "8080"
    instance_protocol = "http"
  }
}