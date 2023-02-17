resource "aws_ecs_task_definition" "mctl-planner" {
  family = "mctl-planner"
  requires_compatibilities = ["EC2"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 256
  container_definitions    = <<TASK_DEFINITION
[
  {
      "name": "nginx",
      "image": "nginx",
      "cpu": 0,
      "portMappings": [
          {
              "name": "nginx-80-tcp",
              "containerPort": 80,
              "hostPort": 80,
              "protocol": "tcp",
              "appProtocol": "http"
          }
      ],
      "essential": true,
      "environment": [],
      "mountPoints": [],
      "volumesFrom": []
  }
]
TASK_DEFINITION

runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}