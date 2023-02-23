############################################################################################################
# Create ECS Cluster Capacity Provider
############################################################################################################
# Unscheduled task 를 감지하고 ECS Cluster EC2 인스턴스 scale-out 할 수 있도록 ECS Capacity Provider 적용
############################################################################################################
resource "aws_ecs_capacity_provider" "ecs_capacity_provider" {
  name = "${var.servicetitle}-${var.environment}-capacity-provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.ecs_asg.arn
    #managed_termination_protection = "ENABLED"
    managed_termination_protection = "DISABLED"

    managed_scaling {
      maximum_scaling_step_size = 100
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 100
      # target_capacity = (기존에 존재하는 인스턴스 개수) / (Task 가 수행하는데 필요한 전체 인스턴스 개수) * 100
    }
  }
}

resource "aws_ecs_cluster_capacity_providers" "ecs_capacity_providers" {
  cluster_name = aws_ecs_cluster.cluster.name

  capacity_providers = [ aws_ecs_capacity_provider.ecs_capacity_provider.name ]

  default_capacity_provider_strategy {
    base              = 0
    weight            = 100
    capacity_provider = aws_ecs_capacity_provider.ecs_capacity_provider.name
  }
}

