########################################################################################
# Create Security Group for ECS-Instance ( 공용임 )
########################################################################################
resource "aws_security_group" "ecs_instance" {
	name 		= "sgrp-${var.servicetitle}-${var.environment}-ecs-instance"
	description = "sg attached to ECS-EC2"

	vpc_id  	= var.vpc_id

	tags  = {
		Name = "sgrp-${var.servicetitle}-${var.environment}-ecs-instance"
		Creator   = "${var.creator}"
		Operator1 = "${var.operator1}"
		Operator2 = "${var.operator2}"
	}

	lifecycle {
    	create_before_destroy = true
	}

	depends_on = [ aws_iam_role.ecsInstanceRole ]
}

#####################################################################################
# Security Group ( ALB <=> ECS-EC2 )
#####################################################################################
##################################
# ingress - ALB
##################################
resource "aws_security_group_rule" "ingress_ec2_ecs_from_all" { # ECS-EC2로는 다 들어와
	description         = "Allow ingress from ALL (internet/fend/bend)"

	security_group_id   = aws_security_group.ecs_instance.id
	cidr_blocks         = [ "0.0.0.0/0" ]

	type      = "ingress"
	protocol  = "-1"	# "tcp"
	from_port = 0       # 80
	to_port   = 0       # 80

	lifecycle {
    	create_before_destroy = true
	}
}

# ingress from ALB(SG)
#resource "aws_security_group_rule" "ecs_ec2_ingress_from_alb" {
#	description              = "SG rule to allow ALB to EC2 traffic"
#
#	security_group_id        = aws_security_group.ecs_instance.id
#	source_security_group_id = aws_security_group.ecs_alb.id
#
#	type        = "ingress"
#	protocol	= -1	# -1 : ALL / "tcp"
#	from_port	= 0
#	to_port		= 0
#
#	lifecycle {
#    	create_before_destroy = true
#	}
#}

##################################
# engress - ALB
##################################
# egress ALL(CIDR)
resource "aws_security_group_rule" "egress_ec2_ecs_to_all" {
	description         = "Allow HTTPS egress to ALL"

	security_group_id   = aws_security_group.ecs_instance.id
	cidr_blocks         = [ "0.0.0.0/0" ]

	type		= "egress"
	protocol	= "tcp"	# -1 : ALL / "tcp"
	from_port	= 443	# 0
	to_port		= 443	# 0

	lifecycle {
    	create_before_destroy = true
	}
}

# egress to ALB(CIDR)
resource "aws_security_group_rule" "ecs_ec2_egress_to_alb" {
	description			= "SG rule to allow ALB to EC2 traffic"

	security_group_id	= aws_security_group.ecs_instance.id
	cidr_blocks         = local.all_snets_CIDRs
	#source_security_group_id = aws_security_group.ecs_alb.id

	type        = "egress"
	protocol	= -1	# -1 : ALL / "tcp"
	from_port	= 0
	to_port		= 0

	lifecycle {
    	create_before_destroy = true
	}
}

#####################################################################################
# Security Group ( Bastion => ECS-EC2 )
#####################################################################################
resource "aws_security_group_rule" "ecs_ec2_ingress_from_bastion_ssh" { # ECS-EC2로는 다 들어와
	description         = "ingress_from_bastion_ssh"

	security_group_id   = aws_security_group.ecs_instance.id
	cidr_blocks         = local.dbms_snets_CIDRs

	type      = "ingress"
	protocol  = "tcp"	# "tcp"
	from_port = 22       # 80
	to_port   = 22       # 80

	lifecycle {
    	create_before_destroy = true
	}
}

#####################################################################################
# Security Group ( ECS-EC2 => Oracle )
#####################################################################################
resource "aws_security_group_rule" "ecs_ec2_egress_to_Oracle" {
	description			= "egress_to_Oracle"

	security_group_id	= aws_security_group.ecs_instance.id
	cidr_blocks         = local.dbms_snets_CIDRs

	type        = "egress"
	protocol	= "tcp"	# -1 : ALL / "tcp"
	from_port	= 1521
	to_port		= 1521

	lifecycle {
    	create_before_destroy = true
	}
}

#####################################################################################
# Security Group ( ECS-EC2 => Aurora )
#####################################################################################
resource "aws_security_group_rule" "ecs_ec2_egress_to_Aurora" {
	description			= "egress_to_Aurora"

	security_group_id	= aws_security_group.ecs_instance.id
	cidr_blocks         = local.dbms_snets_CIDRs

	type        = "egress"
	protocol	= "tcp"	# -1 : ALL / "tcp"
	from_port	= 3306
	to_port		= 3306

	lifecycle {
    	create_before_destroy = true
	}
}