##################################
# Created a Log Group on CloudWatch to get the containers logs
##################################
resource "aws_cloudwatch_log_group" "ecs_log_group" {
	name = "loggroup-${var.servicetitle}-${var.environment}-ecs"

	tags  = {
		Name	= "loggroup-${var.servicetitle}-${var.environment}-ecs"
		Creator   = "${var.creator}"
		Operator1 = "${var.operator1}"
		Operator2 = "${var.operator2}"
	}

	depends_on = [ aws_iam_role.ecsInstanceRole ]
}