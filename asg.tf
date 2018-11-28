
resource "aws_launch_configuration" "fundapps_lc" {
  image_id               = "${lookup(var.amis,var.region)}"
  instance_type          = "t2.micro"
  security_groups        = ["${aws_security_group.instance.id}"]
  key_name               = "${var.key_name}"
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "fundapps" {
  name                      = "fundapps3-terraform-test"
  max_size                  = 5
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 4
  force_delete              = true
  load_balancers = ["${aws_elb.fundapps.name}"]
  launch_configuration      = "${aws_launch_configuration.fundapps_lc.name}"
  vpc_zone_identifier       = ["${aws_subnet.public_subnet.id}", "${aws_subnet.public_subnet1.id}"]

  initial_lifecycle_hook {
    name                 = "fundapps"
    default_result       = "CONTINUE"
    heartbeat_timeout    = 2000
    lifecycle_transition = "autoscaling:EC2_INSTANCE_LAUNCHING"

    notification_metadata = <<EOF
{
  "foo": "fundapps"
}
EOF

    notification_target_arn = "arn:aws:sns:us-east-1:111122223333:Alert"
    role_arn                = "arn:aws:iam::123456789012:role/S3Access"
  }

  tag {
    key                 = "Name"
    value               = "fundapps"
    propagate_at_launch = true
  }

  timeouts {
    delete = "15m"
  }
}

resource "aws_autoscaling_policy" "bat" {
  name                   = "fundapps-terraform-test"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.fundapps.name}"
}

resource "aws_cloudwatch_metric_alarm" "hostcount" {
  alarm_name          = "terraform-test-fundapps"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "HealthyHostCOunt"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Maximum"
  threshold           = "1"

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.fundapps.name}"
  }

  alarm_description = "This metric monitors unhealthy hosts"
  alarm_actions     = "arn:aws:sns:us-east-1:111122223333:Alert"
}

resource "aws_cloudwatch_metric_alarm" "bat" {
  alarm_name          = "terraform-test-foobar5"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.fundapps.name}"
  }

  alarm_description = "This metric monitors ec2 cpu utilization and calls the scaling policy"
  alarm_actions     = ["${aws_autoscaling_policy.bat.arn}"]
}