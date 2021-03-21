data "aws_vpc" "default" {
  default = true
}

resource "aws_ecs_cluster" "fluentd_aggregator" {
  name = "${var.namespace}-fluentd-aggregator"
}

resource "aws_ecr_repository" "fluentd_aggregator" {
  name = "${var.namespace}/fluentd-aggregator"
}

resource "aws_ecs_task_definition" "fluentd_aggregator" {
  family                = "${var.namespace}-fluentd-aggregator"
  container_definitions = <<-JSON
  [
    {
      "name": "fluentd",
      "image": "${aws_ecr_repository.fluentd_aggregator.repository_url}",
      "essential": true,
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${var.namespace}-fluentd-aggregator",
          "awslogs-region": "ap-northeast-1",
          "awslogs-create-group": "true",
          "awslogs-stream-prefix": "fluentd"
        }
      },
      "memoryReservation": 512,
      "portMappings": [
        { "containerPort": 24224, "hostPort": 24224 }
      ]
    }
  ]
  JSON

  cpu    = 999
  memory = 512

  network_mode = "awsvpc"
}

resource "aws_ecs_service" "fluentd_aggregator" {
  name            = aws_ecs_task_definition.fluentd_aggregator.family
  cluster         = aws_ecs_cluster.fluentd_aggregator.name
  task_definition = aws_ecs_task_definition.fluentd_aggregator.arn
  desired_count   = 4

  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0

  load_balancer {
    target_group_arn = aws_lb_target_group.fluentd_aggregator.arn
    container_name   = "fluentd"
    container_port   = 24224
  }

  network_configuration {
    subnets         = [data.aws_subnet.default_1a.id]
    security_groups = [aws_security_group.fluentd_aggregator.id]
  }
}

resource "aws_lb" "fluentd_aggregator" {
  name               = var.namespace
  load_balancer_type = "network"
  internal           = true
  subnets            = [data.aws_subnet.default_1a.id]
}

resource "aws_lb_listener" "fluentd_aggregator" {
  load_balancer_arn = aws_lb.fluentd_aggregator.arn
  port              = 24224
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.fluentd_aggregator.arn
  }
}

resource "aws_lb_target_group" "fluentd_aggregator" {
  name        = var.namespace
  port        = 24224
  protocol    = "TCP"
  target_type = "ip"
  vpc_id      = data.aws_vpc.default.id
}

resource "aws_security_group" "fluentd_aggregator" {
  name   = "${var.namespace}-fluentd-aggregator"
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port   = 24224
    to_port     = 24224
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.default.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "fluentd_aggregator_instances" {
  source = "./ec2"

  name              = "${var.namespace}-fluentd-aggregator"
  cluster           = aws_ecs_cluster.fluentd_aggregator.name
  instance_count    = 1
  subnet_id         = data.aws_subnet.default_1a.id
  security_group_id = aws_security_group.fluentd_aggregator.id
}

output "fluentd_aggregator_cluster_name" {
  value = aws_ecs_cluster.fluentd_aggregator.name
}

output "fluentd_aggregator_repository_url" {
  value = aws_ecr_repository.fluentd_aggregator.repository_url
}

output "fluentd_aggregator_service_name" {
  value = aws_ecs_service.fluentd_aggregator.name
}
