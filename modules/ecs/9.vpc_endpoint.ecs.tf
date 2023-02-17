# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/vpc-endpoints.html
# https://docs.aws.amazon.com/ko_kr/AmazonECS/latest/developerguide/vpc-endpoints.html
# https://github.com/rhythmictech/terraform-aws-ecs-cluster/blob/master/launch_config.tf
# https://github.com/aws-ia/terraform-aws-vpc_endpoints
# https://halfmoon95.tistory.com/entry/Amazon-ECR-%EC%99%80-PrivateLink
# https://brunch.co.kr/@topasvga/1363
# https://www.joinc.co.kr/w/man/12/aws/privatelink
########################################################################################
# Create VPC Endpoint
########################################################################################
resource "aws_vpc_endpoint" "ecs-agent" {
    vpc_id				= var.vpc_id
    service_name		= "com.amazonaws.${var.aws_region}.ecs-agent"
	vpc_endpoint_type	= "Interface"
	subnet_ids          = local.ecs_instance_snet_IDs
	private_dns_enabled = true

	security_group_ids = [ aws_security_group.ecs_vpc_endpoint.id ]

    tags  = {
		Name	= "vpcendpoint-${var.servicetitle}-${var.environment}-ecs-agent"
		Creator   = "${var.creator}"
		Operator1 = "${var.operator1}"
		Operator2 = "${var.operator2}"
	}

	depends_on = [ aws_security_group.ecs_vpc_endpoint ]
}

resource "aws_vpc_endpoint" "ecs-telemetry" {
    vpc_id				= var.vpc_id
    service_name		= "com.amazonaws.${var.aws_region}.ecs-telemetry"
	vpc_endpoint_type	= "Interface"
	subnet_ids          = local.ecs_instance_snet_IDs
	private_dns_enabled = true

	security_group_ids = [ aws_security_group.ecs_vpc_endpoint.id ]

    tags  = {
		Name	= "vpcendpoint-${var.servicetitle}-${var.environment}-ecs-telemetry"
		Creator   = "${var.creator}"
		Operator1 = "${var.operator1}"
		Operator2 = "${var.operator2}"
	}

	depends_on = [ aws_vpc_endpoint.ecs-agent ]
}

resource "aws_vpc_endpoint" "ecs" {
    vpc_id				= var.vpc_id
    service_name		= "com.amazonaws.${var.aws_region}.ecs"
	vpc_endpoint_type	= "Interface"
	subnet_ids          = local.ecs_instance_snet_IDs
	private_dns_enabled = true

	security_group_ids = [ aws_security_group.ecs_vpc_endpoint.id ]

    tags  = {
		Name	= "vpcendpoint-${var.servicetitle}-${var.environment}-ecs"
		Creator   = "${var.creator}"
		Operator1 = "${var.operator1}"
		Operator2 = "${var.operator2}"
	}

	depends_on = [ aws_vpc_endpoint.ecs-telemetry ]
}