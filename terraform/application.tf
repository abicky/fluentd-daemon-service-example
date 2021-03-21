resource "aws_ecs_cluster" "application" {
  name = "${var.namespace}-application"
}

resource "aws_ecr_repository" "application" {
  name = "${var.namespace}/application"
}

resource "aws_ecs_task_definition" "application_using_aggregator" {
  family                = "${var.namespace}-application-using-aggregator"
  container_definitions = <<-JSON
  [
    {
      "name": "application",
      "image": "${aws_ecr_repository.application.repository_url}",
      "essential": true,
      "logConfiguration": {
        "logDriver": "fluentd",
        "options": {
          "tag": "docker.application-using-aggregator",
          "fluentd-address": "${aws_lb.fluentd_aggregator.dns_name}:24224",
          "fluentd-sub-second-precision": "true"
        }
      },
      "memoryReservation": 50
    }
  ]
  JSON
}

resource "aws_ecs_task_definition" "application_using_forwarder" {
  family                = "${var.namespace}-application-using-forwarder"
  container_definitions = <<-JSON
  [
    {
      "name": "application",
      "image": "${aws_ecr_repository.application.repository_url}",
      "essential": true,
      "logConfiguration": {
        "logDriver": "fluentd",
        "options": {
          "tag": "docker.application-using-forwarder",
          "fluentd-address": "unix:///var/run/fluentd/unix.sock",
          "fluentd-sub-second-precision": "true"
        }
      },
      "memoryReservation": 50
    }
  ]
  JSON
}

resource "aws_security_group" "application" {
  name   = "${var.namespace}-application"
  vpc_id = data.aws_vpc.default.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "application_instances" {
  source = "./ec2"

  name              = "${var.namespace}-application"
  cluster           = aws_ecs_cluster.application.name
  instance_count    = 1
  subnet_id         = data.aws_subnet.default_1a.id
  security_group_id = aws_security_group.application.id
}

output "application_cluster_name" {
  value = aws_ecs_cluster.application.name
}

output "application_repository_url" {
  value = aws_ecr_repository.application.repository_url
}

output "application_using_aggregator_task_definition_arn" {
  value = aws_ecs_task_definition.application_using_aggregator.arn
}

output "application_using_forwarder_task_definition_arn" {
  value = aws_ecs_task_definition.application_using_forwarder.arn
}
