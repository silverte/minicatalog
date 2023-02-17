#######################################################
# Create keypair-mwadmin-ecs-ec2
#######################################################
#resource "aws_key_pair" "ecs_key_pair" {
#	key_name   = var.ECS_key_pair.key_name		# "keypair-ECS-ssh",  변경할것 : "${var.ECS_key_pair.key_name}-${var.creator}" => "keypair-ECS-ssh-05599"
#	public_key = var.ECS_key_pair.public_key
#
#	tags  = {
#		Name	= "keypair-${var.servicetitle}-${var.environment}-${var.aws_region_code}-ecs-ec2"
#		Creator   = "${var.creator}"
#		Operator1 = "${var.operator1}"
#		Operator2 = "${var.operator2}"
#	}
#
#	lifecycle {
#    	create_before_destroy = true
#	}
#
#	depends_on = [ aws_iam_role.ecsInstanceRole ]
#}