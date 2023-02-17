###########################################################
# Create IAM Role for ECS Instance Role ( ecsInstanceRole )
###########################################################

resource "aws_iam_role" "ecsInstanceRole" {
  name = "role-${var.servicetitle}-${var.environment}-ecs-ecsInstanceRole"
  path = "/service-role/"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_AmazonEC2ContainerServiceforEC2Role" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
	role		= aws_iam_role.ecsInstanceRole.name
	# Default policy for the Amazon EC2 Role for Amazon EC2 Container Service.

	depends_on = [ aws_iam_role.ecsInstanceRole ]
}