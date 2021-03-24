resource "aws_ecr_repository" "fluentd_forwarder" {
  name = "${var.namespace}/fluentd-forwarder"
}

resource "aws_ecs_task_definition" "fluentd_forwarder" {
  family                = "${var.namespace}-fluentd-forwarder"
  container_definitions = <<-JSON
  [
    {
      "name": "fluentd",
      "image": "${aws_ecr_repository.fluentd_forwarder.repository_url}",
      "environment": [
        { "name": "FLUENTD_AGGREGATOR_HOST", "value": "${aws_lb.fluentd_aggregator.dns_name}" }
      ],
      "essential": true,
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${var.namespace}-fluentd-forwarder",
          "awslogs-region": "ap-northeast-1",
          "awslogs-create-group": "true",
          "awslogs-stream-prefix": "fluentd"
        }
      },
      "memoryReservation": 50,
      "mountPoints": [
        { "containerPath": "/fluentd/var/run", "sourceVolume": "var-run-fluentd" }
      ],
      "user": "root",
      "dockerLabels": {
        "com.datadoghq.ad.check_names": "[\"fluentd\"]",
        "com.datadoghq.ad.init_configs": "[{}]",
        "com.datadoghq.ad.instances": "[{\"monitor_agent_url\": \"http://%%host%%:24220/api/plugins.json\"}]"
      }
    }
  ]
  JSON

  volume {
    name      = "var-run-fluentd"
    host_path = "/var/run/fluentd"
  }
}

resource "aws_ecs_service" "fluentd_forwarder" {
  name                = aws_ecs_task_definition.fluentd_forwarder.family
  cluster             = aws_ecs_cluster.application.name
  task_definition     = aws_ecs_task_definition.fluentd_forwarder.arn
  scheduling_strategy = "DAEMON"
}

output "fluentd_forwarder_repository_url" {
  value = aws_ecr_repository.fluentd_forwarder.repository_url
}

output "fluentd_forwarder_service_name" {
  value = aws_ecs_service.fluentd_forwarder.name
}
