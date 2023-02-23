##################################
# Create ECS Auto-Scaling-Group
##################################
# ecs 에서 사용할 autoscaling group 정의
# Scale-In 시 InService 인스턴스가 아닌 미사용 인스턴스 제거를 위한 인스턴스 축소 보호 기능 활성화
resource "aws_autoscaling_group" "ecs_asg" {
    name                      = "asg-${var.servicetitle}-${var.environment}-ecs"
    launch_configuration      = aws_launch_configuration.launch_conf.name
    
    desired_capacity          = var.ECS_Cluster_Info.min_size
    min_size                  = var.ECS_Cluster_Info.min_size
    max_size                  = var.ECS_Cluster_Info.max_size

    health_check_grace_period = 300
    health_check_type         = "EC2"
    
    vpc_zone_identifier       = local.ecs_instance_snet_IDs # ["subnet-08343ddcedb97d638", "subnet-0fc72d5b38b4b8e3e"]

    termination_policies      = [ "OldestInstance" ]

    protect_from_scale_in     = false    # Scale-In 시 InService 인스턴스가 아닌 미사용 인스턴스 제거를 위한 인스턴스 축소 보호 기능 활성화

    lifecycle {
        create_before_destroy = true
    }

    # ECS-EC2 인스턴스별 Name Tag 추가
    tag {
        key    = "Name"
        value  = "ec2-${var.servicetitle}-${var.environment}-ecs-instance"
        propagate_at_launch = true    
    }

    depends_on = [ aws_launch_configuration.launch_conf ]
}

##################################
# Add Common Tag to ECS Auto-Scaling-Group
##################################
resource "aws_autoscaling_group_tag" "add_ServiceName" {
  autoscaling_group_name = aws_autoscaling_group.ecs_asg.name

  tag {
    key   = "ServiceName"
    value = var.servicetitle

    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group_tag" "add_Environment" {
  autoscaling_group_name = aws_autoscaling_group.ecs_asg.name

  tag {
    key   = "Environment"
    value = var.environment

    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group_tag" "add_Personalinformation" {
  autoscaling_group_name = aws_autoscaling_group.ecs_asg.name

  tag {
    key   = "Personalinformation"
    value = var.personalinformation

    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group_tag" "add_creator" {
  autoscaling_group_name = aws_autoscaling_group.ecs_asg.name

  tag {
    key   = "creator"
    value = var.creator

    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group_tag" "add_operator1" {
  autoscaling_group_name = aws_autoscaling_group.ecs_asg.name

  tag {
    key   = "operator1"
    value = var.operator1

    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group_tag" "add_operator2" {
  autoscaling_group_name = aws_autoscaling_group.ecs_asg.name

  tag {
    key   = "operator2"
    value = var.operator1

    propagate_at_launch = true
  }
}

###############################################
# Output
###############################################
output "ecs_asg" {
	value = aws_autoscaling_group.ecs_asg
}