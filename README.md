# terraform-test
simple terraform ASG etc

application stack in Terraform consisting of an ELB and ASG. The stack should setup ASG scaling alarms, cloudwatch
ELB unhealthy host alarms, IAM role & policy, ELB logs and security groups.The instance should be able to access S3. The application should
be a minimal application that has a status endpoint
