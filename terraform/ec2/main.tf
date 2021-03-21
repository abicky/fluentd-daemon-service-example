variable "cluster" {}
variable "name" {}
variable "instance_count" {}
variable "subnet_id" {}
variable "security_group_id" {}

data "aws_ami" "most_recent_ecs_optimized" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-2.0.*-x86_64-ebs"]
  }
}

resource "aws_instance" "main" {
  count = var.instance_count

  ami           = data.aws_ami.most_recent_ecs_optimized.image_id
  instance_type = "c5.xlarge"

  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]

  associate_public_ip_address = true

  iam_instance_profile = "ecsInstanceRole"

  tags = {
    Name = var.name
  }

  user_data = <<-DATA
  #!/bin/bash
  cat <<'EOF' >> /etc/ecs/ecs.config
  ECS_CLUSTER=${var.cluster}
  ECS_AVAILABLE_LOGGING_DRIVERS=["awslogs","fluentd"]
  EOF
  DATA
}
