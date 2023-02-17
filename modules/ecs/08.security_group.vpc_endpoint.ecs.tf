########################################################################################
# Create Security Group for VPC-EndPoint ( ecs, ecs-agent, ecs-telemetry )
########################################################################################
resource "aws_security_group" "ecs_vpc_endpoint" {
	name 		= "sgrp-${var.servicetitle}-${var.environment}-vpcendpoint-ecs"
	description = "Attached to ecs vpc endpoint"

	vpc_id  	= var.vpc_id

	tags  = {
		Name	= "sgrp-${var.servicetitle}-${var.environment}-vpcendpoint-ecs"
		Creator   = "${var.creator}"
		Operator1 = "${var.operator1}"
		Operator2 = "${var.operator2}"
	}

	lifecycle {
    	create_before_destroy = true
	}

	depends_on = [ aws_iam_role.ecsInstanceRole ]
}

# https://docs.aws.amazon.com/ko_kr/vpc/latest/privatelink/vpce-interface.html
####################################################################
# SG Rule은 SG 기준 ingress/egress만 설정
####################################################################
# ingress from ECS-EC2(SG)
resource "aws_security_group_rule" "ecs_ingress_from_ec2" {
	description         = "Allow ingress from ecs"

    security_group_id   = aws_security_group.ecs_vpc_endpoint.id
	source_security_group_id = aws_security_group.ecs_instance.id

    type        = "ingress"
	protocol    = "tcp"	#-1
	from_port   = 443	#0
	to_port     = 443	#0

	lifecycle {
		create_before_destroy = true
	}
}

# egress to ECS-EC2(SG)
# 1. egress 443 port만 열어도 동작한다.
# 2. egress 안열어도 잘 동작 한다.
#resource "aws_security_group_rule" "ecs_egress_to_all" {
#	description         = "Allow egress to aws-ecs"
#
#    security_group_id   = aws_security_group.ecs_vpc_endpoint.id
#	source_security_group_id = aws_security_group.ecs_instance.id
#
#    type        = "egress"
#	protocol    = "tcp"
#	from_port   = 443 
#	to_port     = 443   
#
#	lifecycle {
#		create_before_destroy = true
#	}
#}













####################################################################
# SG Rule은 SG 기준 ingress/egress만 하면 충분하다
####################################################################
# ingress from ALL(CIDR)
#resource "aws_security_group_rule" "ingress_from_ec2_ecs_cidr" {
#	description         = "Allow ingress from ecs"
#
#   security_group_id   = aws_security_group.ecs_vpc_endpoint.id
#	cidr_blocks			= [ "0.0.0.0/0" ]
#	# [ "0.0.0.0/0" ]
#	# local.ecs_instance_snet_CIDRs 
#
#    type        = "ingress"
#	protocol    = "-1"	#-1      # "tcp"
#	from_port   = 0	#0       # 80
#	to_port     = 0	#0       # 80
#
#	lifecycle {
#		create_before_destroy = true
#	}
#}

# egress to ALL(CIDR)
#resource "aws_security_group_rule" "egress_to_all_cidr" {
#	description         = "Allow egress to aws"
#
#   security_group_id   = aws_security_group.ecs_vpc_endpoint.id
#	cidr_blocks			= [ "0.0.0.0/0" ]
#						# local.ecs_instance_snet_CIDRs
#						# [ "0.0.0.0/0" ]
#
#    type        = "egress"
#	protocol    = "-1"    # "tcp"
#	from_port   = 0       # 80
#	to_port     = 0       # 80    
#
#	lifecycle {
#		create_before_destroy = true
#	}
#}








#resource "aws_security_group_rule" "ingress_from_ecs_instance" {
#	description         = "Allow ingress from ecs"
#
#    security_group_id   = aws_security_group.ecs_vpc_endpoint.id
#	cidr_blocks			= local.ecs_instance_snet_CIDRs # [ "0.0.0.0/0" ]
#	#source_security_group_id = aws_security_group.ecs_instance.id
#
#    type        = "ingress"
#	protocol    = "tcp"	#-1      # "tcp"
#	from_port   = 443	#0       # 80
#	to_port     = 443	#0       # 80
#
#    #source_security_group_id = aws_security_group.ecs_instance.id
#
#	lifecycle {
#		create_before_destroy = true
#	}
#}


#resource "aws_security_group_rule" "egress_vpc_to_ecs_instance" {
#	description         = "Allow egress to aws"
#
#    security_group_id   = aws_security_group.ecs_vpc_endpoint.id
#	source_security_group_id = aws_security_group.ecs_instance.id	
#	#cidr_blocks			= [ "0.0.0.0/0" ]
#						# local.ecs_instance_snet_CIDRs
#						# [ "0.0.0.0/0" ]
#	# source_security_group_id = aws_security_group.ecs_instance.id						
#
#    type        = "egress"
#	protocol    = -1    # "tcp"
#	from_port   = 0       # 80
#	to_port     = 0       # 80    
#
#	lifecycle {
#		create_before_destroy = true
#	}
#}

#resource "aws_security_group_rule" "ingress_from_ecs_sg" {
#	description         = "Allow ingress from ecs"
#
#    security_group_id   = aws_security_group.ecs_vpc_endpoint.id
#	#cidr_blocks			= [ "0.0.0.0/0" ]
#	source_security_group_id = aws_security_group.ecs_instance.id
#
#    type        = "ingress"
#	protocol    = -1    # "tcp"
#	from_port   = 0       # 80
#	to_port     = 0       # 80
#
#    #source_security_group_id = aws_security_group.ecs_instance.id
#
#	lifecycle {
#		create_before_destroy = true
#	}
#}

