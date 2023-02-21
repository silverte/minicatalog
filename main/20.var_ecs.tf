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
locals {
    ##############################
    # ECS Cluster 설정 ( W/L별 수정 )
    ##############################    
    ECS_Cluster_Info    = {
        instance_type       = "m5.large"  
        min_size            = 2            # desired_capacity 으로 같이 사용함 ( 25.autoscaling_group.tf )
        max_size            = 4
        volume_size         = 20
    }
    ECS_LB_Subnets      = ["public1-a", "public2-c"]                # internet expose subnets
    ECS_Inst_Subnets    = ["private1-a", "private2-c"]              # ecs subnet
    DBMS_Inst_Subnets   = ["private-db1-a", "private-db2-c"]	    # db subnet

    ##############################
    # ECS 운영자 설정 ( W/L별 수정 )
    ##############################
    ECS_operator_ip = []		# 운영자 Local IP
    ECS_key_pair    = {}
    ECS_key_pair_name = "keypair-sample-dev"
    ##############################
    # ECS Sample 설정 ( 그냥 놔둠 )
    ##############################
    ECS_Sample = {
        # task_def_name   = "sample_taskdefinition"        
        # cpu             = 256
        # memory          = 256
        # service_name    = "sample_service"
        # conatiner_id    = "ealen/echo-server:latest" # "harbor.biz-think.net/comm/api-nateonbiz:1.0"
    }

    ##############################
    # Tags - ECS 운영자 사번 ( W/L별 수정 )
    ##############################
    ECS_creator             = "07326"
    ECS_operator1           = ""
    ECS_operator2           = ""
}