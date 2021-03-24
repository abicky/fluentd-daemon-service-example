variable "dd_api_key" {}

resource "aws_ecs_task_definition" "datadog_agent" {
  # cf. https://docs.datadoghq.com/resources/json/datadog-agent-ecs.json
  family = "${var.namespace}-datadog-agent"

  container_definitions = <<-JSON
  [
    {
      "name": "datadog-agent",
      "image": "datadog/agent:latest",
      "cpu": 100,
      "memory": 512,
      "essential": true,
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${var.namespace}-datadog-agent",
          "awslogs-region": "ap-northeast-1",
          "awslogs-create-group": "true",
          "awslogs-stream-prefix": "datadog-agent"
        }
      },
      "mountPoints": [
        {
          "containerPath": "/var/run/docker.sock",
          "sourceVolume": "docker_sock",
          "readOnly": null
        },
        {
          "containerPath": "/host/sys/fs/cgroup",
          "sourceVolume": "cgroup",
          "readOnly": null
        },
        {
          "containerPath": "/host/proc",
          "sourceVolume": "proc",
          "readOnly": null
        }
      ],
      "environment": [
        {
          "name": "DD_API_KEY",
          "value": "${var.dd_api_key}"
        },
        {
          "name": "DD_SITE",
          "value": "datadoghq.com"
        }
      ]
    }
  ]
  JSON

  volume {
    name      = "docker_sock"
    host_path = "/var/run/docker.sock"
  }

  volume {
    name      = "proc"
    host_path = "/proc/"
  }

  volume {
    name      = "cgroup"
    host_path = "/sys/fs/cgroup/"
  }
}

resource "aws_ecs_service" "application_datadog_agent" {
  name                = aws_ecs_task_definition.datadog_agent.family
  cluster             = aws_ecs_cluster.application.name
  task_definition     = aws_ecs_task_definition.datadog_agent.arn
  scheduling_strategy = "DAEMON"
}

resource "aws_ecs_service" "fluentd_aggregator_datadog_agent" {
  name                = aws_ecs_task_definition.datadog_agent.family
  cluster             = aws_ecs_cluster.fluentd_aggregator.name
  task_definition     = aws_ecs_task_definition.datadog_agent.arn
  scheduling_strategy = "DAEMON"
}
