########################################################################################
# Create Security Group for ECS-ALB ( Sample App 용 ALB 임 )
########################################################################################
resource "aws_security_group" "ecs_alb" {
	name 		= "sgrp-${var.servicetitle}-${var.environment}-alb-ecs"
	description = "sg attached to ALB"

	vpc_id  	= var.vpc_id

	tags  = {
		Name	= "sgrp-${var.servicetitle}-${var.environment}-ecs-alb"
		Creator   = "${var.creator}"
		Operator1 = "${var.operator1}"
		Operator2 = "${var.operator2}"
	}

	lifecycle {
    	create_before_destroy = true
	}

	depends_on = [ aws_iam_role.ecsInstanceRole ]
}

##################################
# Add Rule to Security Group of ALB-ECS
##################################

# ingress from ALL(CIDR)
resource "aws_security_group_rule" "ingress_alb_ecs_from_all" {		# ALB로는 다 들어와
	description			= "Allow ingress from ALL (internet/fend/bend)"

	security_group_id	= aws_security_group.ecs_alb.id
	cidr_blocks			= [ "0.0.0.0/0" ]

	type      = "ingress"
	protocol  = "-1"	# "tcp"
	from_port = 0       # 80
	to_port   = 0       # 80

	lifecycle {
    	create_before_destroy = true
	}
}

# egress to Operator(CIDR)
# ALB/NLB는 ingress만 0.0.0.0/0 되어있으면 egress 0.0.0.0/0 은 필요 없음 ( 단방향 방화벽만 Open 되어있으면 연결된 세션으로 양방향 다 된다. )
#resource "aws_security_group_rule" "egress_alb_ecs_to_operator" {
#	description			= "Allow egress to Operator IP"
#
#	security_group_id	= aws_security_group.ecs_alb.id
#	cidr_blocks			= var.ECS_operator_ip
#	#cidr_blocks       = var.EKS_operator_ip
#	#cidr_blocks       = local.all_snets_CIDRs	
#	#cidr_blocks       = [ "0.0.0.0/0" ]
#
#	type      = "egress"
#	protocol  = "-1"	# "tcp"
#	from_port = 0
#	to_port   = 0
#
#	lifecycle {
#    	create_before_destroy = true
#	}
#}

##################################
# Create - Sample Application Rule
##################################
# egress to ECS-EC2(SG)
# ECS 샘플 ALB는 ECS-ECS가 있는 local.ecs_instance_snet_CIDRs 로만 나갈 수 있으면 된다.
resource "aws_security_group_rule" "egress_alb_ecs_to_ec2_ecs_sg" {		# ALB 는 ECS-EC2로는 다 나갈 수 있어
	description			= "Allow egress to ECS-EC2(private-dup)"

    security_group_id	= aws_security_group.ecs_alb.id
	cidr_blocks			= local.ecs_instance_snet_CIDRs
	#cidr_blocks       = var.EKS_operator_ip
	#cidr_blocks       = local.all_snets_CIDRs	
	#cidr_blocks       = [ "0.0.0.0/0" ]
	#source_security_group_id = local.ecs_instance_snet_CIDRs

    type		= "egress"
    protocol	= -1
    from_port	= 0
    to_port		= 0

	lifecycle {
		create_before_destroy = true
	}
}