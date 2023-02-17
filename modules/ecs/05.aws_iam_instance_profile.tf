##################################
# Create Profile
##################################
#autoscaling group 의 instance 에서 사용할 instance profile 
resource "aws_iam_instance_profile" "ecs_instance_profile" {
	name = "${var.servicetitle}-${var.environment}-ecsInstanceRole-profile"
	role = aws_iam_role.ecsInstanceRole.name

	tags  = {
		Name	= "${var.servicetitle}-${var.environment}-ecsInstanceRole-profile"
		Creator   = "${var.creator}"
		Operator1 = "${var.operator1}"
		Operator2 = "${var.operator2}"
	}
 
	depends_on = [ aws_iam_role.ecsInstanceRole ]
}