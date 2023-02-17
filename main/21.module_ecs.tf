#####################################################################
##  File path                               | Resource List
##  ---------------------------------------------------------------
##  03.iam_role.ecs_instance_role.tf        aws_iam_role.ecsInstanceRole
##  03.iam_role.ecs_instance_role.tf        aws_iam_role_policy_attachment.ecs_ec2_role
##  03.iam_role.ecs_instance_role.tf        aws_iam_role_policy_attachment.ssm_core_role
##  04.aws_iam_instance_profile.tf          aws_iam_instance_profile.ecs_instance_profile
##  05.security_group.alb.tf                aws_security_group.ecs_alb
##  05.security_group.alb.tf                aws_security_group_rule.ingress_alb_ecs_from_all
##  05.security_group.alb.tf                aws_security_group_rule.egress_alb_ecs_to_operator
##  05.security_group.alb.tf                aws_security_group_rule.egress_alb_ecs_to_ec2_ecs_sg
##  06.security_group.ecs_instance.tf       aws_security_group.ecs_instance
##  06.security_group.ecs_instance.tf       aws_security_group_rule.ingress_ec2_ecs_from_all
##  06.security_group.ecs_instance.tf       aws_security_group_rule.egress_ec2_ecs_to_all
##  06.security_group.ecs_instance.tf       aws_security_group_rule.ecs_ec2_ingress_from_alb
##  06.security_group.ecs_instance.tf       aws_security_group_rule.ecs_ec2_egress_to_alb
##  06.security_group.ecs_instance.tf       aws_security_group_rule.ecs_ec2_ingress_to_vpc_endpoint
##  06.security_group.ecs_instance.tf       aws_security_group_rule.ecs_ec2_egress_to_vpc_endpoint
##  07.security_group.vpc_endpoint.ecs.tf   aws_security_group.ecs_vpc_endpoint
##  07.security_group.vpc_endpoint.ecs.tf   aws_security_group_rule.ingress_from_ec2_ecs_sg
##  07.security_group.vpc_endpoint.ecs.tf   aws_security_group_rule.egress_to_ec2_ecs_sg
##  08.vpc_endpoint.ecs.tf                  aws_vpc_endpoint.ecs
##  08.vpc_endpoint.ecs.tf                  aws_vpc_endpoint.ecs-agent
##  08.vpc_endpoint.ecs.tf                  aws_vpc_endpoint.ecs-telemetry
##  09.ecs_cluster.tf                       aws_ecs_cluster.cluster
##  10.cloudwatch_log_group.tf              aws_cloudwatch_log_group.ecs_log_group
##  12.key_pair.tf                          aws_key_pair.ECS_key_pair
##  13.launchtemplate.tf                    aws_launch_configuration.launch_conf
##  14.autoscaling_group.tf                 aws_autoscaling_group.ecs_asg
##  30.sample.app.tf                        aws_ecs_task_definition.sample_task_definition
##  30.sample.app.tf                        aws_lb.sample
##  30.sample.app.tf                        aws_lb_listener.http
##  30.sample.app.tf                        aws_lb_target_group.sample_target_group
##  30.sample.app.tf                        aws_ecs_service.sample_service
#####################################################################
#####################################################################
##  Input Variables List
##  ------------------------------------------------------------------------------------------------------------
##  Variable Name                  |  Type     | dir path                   | Meaning
##  ------------------------------------------------------------------------------------------------------------
##  local.region                   | String    | ./01.var_common.tf         | AWS Region
##  local.aws_region_code          | String    | ./01.var_common.tf         | Code of AWS Region (abbreviation)
##  module.vpc.vpc_id              | String    | ./03.module_vpc.tf         | VPC ID - Mandatory (output info, ../module/vpc/02.vpc.tf)
##  module.network.out_snets_info  | map       | ./04.module_network.tf     | Subnet information (output info, ../module/network/03.snets.tf)
##  local.subnet_information       | Map       | ./02.var_network.tf        | Subnet Informations
##  local.tgw_id                   | String    | ./02.var_network.tf        | Transit Gateway ID
##  local.route_prefix_list        | List      | ./02.var_network.tf        | List of route prefix values for On-Prem. routing
##  local.tags                     | Map       | ./01.var_common.tf         | Default Tag Information
##  local.tags.ServiceName         | String    | ./01.var_common.tf         | Service Title
##  local.tags.Environment         | String    | ./01.var_common.tf         | Environment of this system [prd | dev| stg | qa]
##  local.tags.Personalinformation | String    | ./01.var_common.tf         | Existence of Personal information
#####################################################################
#####################################################################
##  User Define Variables List
##  ------------------------------------------------------------------------------------------------------------
##  Variable Name                   |  Type     | Meaning 
##  ------------------------------------------------------------------------------------------------------------
##  ECS_LB_Subnets                  |  set      | 샘플 LB 생성 대상 Subnet
##  ECS_Inst_Subnets                |  set      | ECS Node 생성 대상 Subnet
##  ECS_operator_ip                 |  set      | 샘플 LB egress 대상 IP ( Operator의 IP )
##  ECS_key_pair                    |  map(any) | ECS 운영자 SSH Key 정보 ( ECS Node EC2 SSH 접속용 )
##  ECS_Cluster_Info                |  map(any) | ECS 인스턴스 설정 정보 ( Instance Spec, Desire/Min/Max )
##  ECS_Sample                      |  map(any) | ECS 인스턴스 설정 정보 ( Instance Spec, Desire/Min/Max )
##  creator                         |  String   | ECS 생성자 사번
##  operator1                       |  String   | ECS 운영자 사번
##  operator2                       |  String   | ECS 운영자 사번
#####################################################################
#########################################
##  Choose ECS Cluster module - Edit module "ecs"
#########################################
module "ecs" {
    ###############
    # Choose ECS module
    ###############
    source = "../modules/ecs"

    ###############
    # Depends_on (Network 구성 후 ECS 구성)
    ###############
    depends_on = [ module.network ]

    ##############################
    # ECS Cluster 설정
    ##############################    
    ECS_Cluster_Info    = local.ECS_Cluster_Info
    ECS_LB_Subnets      = local.ECS_LB_Subnets
    ECS_Inst_Subnets    = local.ECS_Inst_Subnets
    DBMS_Inst_Subnets   = local.DBMS_Inst_Subnets

    ##############################
    # ECS 운영자 설정
    ##############################
    ECS_operator_ip     = local.ECS_operator_ip    
    ECS_key_pair        = local.ECS_key_pair
    ECS_key_pair_name   = local.ECS_key_pair_name

    ##############################
    # ECS Sample 설정
    ##############################
    ECS_Sample          = local.ECS_Sample

    ##############################
    # Output Info ( module.vpc / module.network )
    ##############################
    vpc_id              = module.vpc.vpc_id
    out_snets_info      = module.network.out_snets_info

    ##############################
    # Tags - ECS 운영자 사번
    ##############################
    creator             = local.ECS_creator
    operator1           = local.ECS_operator1
    operator2           = local.ECS_operator2
    
    ##############################
    # 공통 설정 - ( 01.var_common.tf )
    ##############################
    aws_region          = local.region
    aws_region_code     = local.aws_region_code
    aws_profile         = local.aws_profile

    ##############################
	# 공통 설정 - Tag
	##############################
	tags                = local.tags
    servicetitle        = local.tags.ServiceName
    environment         = local.tags.Environment
    personalinformation = local.tags.Personalinformation
}

###############################################
# Output of module.ecs
###############################################
#output "ecs_asg" {
#    value = module.ecs.ecs_asg
#}
#
#output "ecs_instance_snet_IDs" {
#	value 		= module.ecs.ecs_instance_snet_IDs
#}
#
#output "ecs_instance_snet_CIDRs" {
#	value 		= module.ecs.ecs_instance_snet_CIDRs
#}
#
#output "ecs_sample_lb_dns" {
#	value = module.ecs.ecs_sample_lb_dns
#}
#
#output "sample_task_definition" {
#	value = module.ecs.sample_task_definition
#}
#
#output "sample_ecs_service" {
#	value = module.ecs.sample_ecs_service
#}