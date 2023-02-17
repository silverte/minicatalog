#####################################################################
# Create IAM Role for ECS TaskExecution Role ( ecsTaskExecutionRole )
#####################################################################
resource "aws_iam_role" "ecsTaskExecutionRole" {
	name = "role-${var.servicetitle}-${var.environment}-ecs-ecsTaskExecutionRole"
    path = "/service-role/"

  	assume_role_policy = jsonencode({
		"Version" : "2012-10-17",
		"Statement" : [
			{
				"Sid": "",	
				"Effect" : "Allow",
				"Principal" : {
					"Service" : "ecs-tasks.amazonaws.com"
				},
				"Action" : [
					"sts:AssumeRole"
				]
			}
		]
	})
}

resource "aws_iam_role_policy_attachment" "ecs_AmazonECSTaskExecutionRolePolicy" {
	policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
	role       = aws_iam_role.ecsTaskExecutionRole.name
	# Provides access to other AWS service resources that are required to run Amazon ECS tasks

	depends_on = [ aws_iam_role.ecsTaskExecutionRole ]
}

resource "aws_iam_role_policy_attachment" "ecs_AmazonS3FullAccess" {	
	policy_arn	= "arn:aws:iam::aws:policy/AmazonS3FullAccess"
	role		= aws_iam_role.ecsTaskExecutionRole.name
	# Provides full access to all buckets via the AWS Management Console.

	depends_on = [ aws_iam_role.ecsTaskExecutionRole ]
}