########################################################################################
# Create ECS Cluster ( https://dev.to/thnery/create-an-aws-ecs-cluster-using-terraform-g80 )
########################################################################################
resource "aws_ecs_cluster" "cluster" {
	name = "ecs-cluster-${var.servicetitle}-${var.environment}"

	setting {
		name  = "containerInsights"
		value = "enabled"
	}

	lifecycle {
		create_before_destroy = true
	}

	tags  = {
		Name	= "ecs-cluster-${var.servicetitle}-${var.environment}"
		Creator   = "${var.creator}"
		Operator1 = "${var.operator1}"
		Operator2 = "${var.operator2}"
	}

	depends_on = [ 
		aws_iam_role.ecsInstanceRole,
		aws_iam_role.ecsTaskExecutionRole
	]
}