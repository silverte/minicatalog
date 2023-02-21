# resource "aws_ecs_service" "ecs_service" {
#   name            = "mctl-planner-svc"
#   cluster         = aws_ecs_cluster.cluster.id
#   task_definition = aws_ecs_task_definition.mctl-planner.arn
#   desired_count   = 2

#   capacity_provider_strategy {
#     capacity_provider = aws_ecs_capacity_provider.ecs_capacity_provider.name
#     base = 0
#     weight = 100
#   }

#   load_balancer {
#     target_group_arn = var.alb_tgr_arn
#     container_name   = "nginx"
#     container_port   = 80
#   }

#   deployment_circuit_breaker {
#     enable = true
#     rollback = true
#   }
#   deployment_maximum_percent = 200
#   deployment_minimum_healthy_percent = 100

#   network_configuration {
#     subnets = local.ecs_instance_snet_IDs
#     security_groups = [aws_security_group.ecs_instance.id]
#     assign_public_ip = false
#   }

#    ordered_placement_strategy {
#     type  = "spread"
#     field = "host"
#   }
#   #health_check_grace_period_seconds = 360

#   depends_on      = [aws_ecs_task_definition.mctl-planner]
# }