#####################################################################
##  TemplateName:  25.module_alb.tf
##  Purpose:    Create Network Resources
##  ---------------------------------------------------------------
##  Version  | Date        | Developer        | Update Reason
##  ---------------------------------------------------------------
##  1.0      |             |                  | First Version
#####################################################################

#######################################################
## Create Network Resources
#######################################################

#####################################################################
##  Resource List                       | File path
##  ---------------------------------------------------------------
##  aws_lb_target_group                 | ../modules/alb/02.alb_target_group.
##  aws_lb_target_group_attachment      | ../modules/alb/02.alb_target_group.tf
##  aws_lb                              | ../modules/alb/03.alb.tf
##  aws_lb_listener                     | ../modules/alb/03.alb.tf
##  aws_lb_listener_rule                | ../modules/alb/04.listener_rule.tf
#####################################################################

################################################################################################################
##  Input Variables List
##  ------------------------------------------------------------------------------------------------------------
##  Variable Name                    |  Type     | dir path            | Meaning 
##  ------------------------------------------------------------------------------------------------------------
##  local.region                     | String    | ./var_common.tf     | AWS Region
##  local.aws_region_code            | String    | ./var_common.tf     | Code of AWS Region (abbreviation)
##  module.vpc.vpc_id                | String    | ./module_vpc.tf     | VPC ID - Mandatory
##  module.network.out_snets_info    | Map       | ./module_network.tf | Subnet Information - Mandatory
##  module.alb-sg.out_sg_info        | Map       | ./module_sg.tf      | SG Information for alb
##  local.application_loadbalancer   | Map       | ./var_alb.tf        | ALBs Information (Including listeners & rules)
##  local.forward_rules              | Map       | ./var_alb.tf        | Target groups(when using forward action) Information
##  local.redirect_rules             | Map       | ./var_alb.tf        | Redirect rules Information
##  local.fixed_response_rules       | Map       | ./var_alb.tf        | Fixed_response rules Information
##  local.rule_conditions            | Map       | ./var_alb.tf        | Conditions Information
##  local.alb_sg_information         | Map       | ./var_sg_for_alb.tf | SG Information for SG creation
##  local.tags                       | Map       | ./var_common.tf     | Default Tag Information
##  local.tags.ServiceName           | String    | ./var_common.tf     | Service Title
##  local.tags.Environment           | String    | ./var_common.tf     | Environment of this system [prd | dev| stg | qa]
##  local.alb_Creator                | String    | ./var_alb.tf        | Employee Number of Creator
##  local.alb_Operator1              | String    | ./var_alb.tf        | Employee Number of Main Operator
##  local.alb_Operator2              | String    | ./var_alb.tf        | Employee Number of Sub Operator
##########################################################################################################

module "alb" {
  ###############
  # Choose network module
  ###############
  source  = "../modules/alb"

  ###############
  # Region
  ###############
  aws_region            = local.region
  aws_region_code       = local.aws_region_code

  ###############
  # Module Output
  ###############
  vpc_id                = module.vpc.vpc_id      # vpc 생성 후 vpc id 값을 저장
  snets_info            = module.network.out_snets_info

  ###############
  # Network Load Balancer
  ###############
  application_loadbalancer = local.application_loadbalancer
  
  alb_listener = flatten([
    for lb_key, lb_value in local.application_loadbalancer : [
      for listener_value in lb_value.listeners : {
        internal = lb_value.internal
        lb_key = lb_key
        listener_key = "${lb_key}.${listener_value.port}"
        port = lookup(listener_value, "port", null)
        protocol = lookup(listener_value, "protocol", null)
        ssl_policy = lookup(listener_value, "ssl_policy", null)
        certificate_arn = lookup(listener_value, "certificate_arn", null)
        default_action = lookup(listener_value, "default_action", null)
        default_rule = lookup(listener_value, "default_rule", null)
      }
    ]
  ])
    
  alb_target_list = flatten([
    for target_group_key, target_group_value in local.forward_rules : [
      for target_key, target_value in target_group_value.target_id : {
        target_group_key = target_group_key
        target_key = "${target_group_key}.${target_value}"
        target_type = target_group_value.target_type
        target_id = target_value
        target_in_vpc = target_group_value.target_in_vpc
      }
    ]
  ])
  
  alb_rule = flatten([
    for lb_key, lb_value in local.application_loadbalancer : [
      for listener_value in lb_value.listeners : [
        for rule_value in listener_value.additional_rules : {
          lb_key = lb_key
          listener_key = "${lb_key}.${listener_value.port}"
          rule_key = "${lb_key}.${listener_value.port}.${rule_value.priority}"
          priority = lookup(rule_value, "priority", null)
          condition = lookup(rule_value, "condition", null)
          action = lookup(rule_value, "action", null)
          rule = lookup(rule_value, "rule", null)
        
        }
      ]
    ]
  ])
  
  alb_rule_condition = flatten([
    for lb_key, lb_value in local.application_loadbalancer : [
      for listener_value in lb_value.listeners : [
        for rule_value in listener_value.additional_rules : [
          for condition in rule_value.condition : {
          lb_key = lb_key
          listener_key = "${lb_key}.${listener_value.port}"
          rule_key = "${lb_key}.${listener_value.port}.${rule_value.priority}"
          priority = lookup(rule_value, "priority", null)
          condition = lookup(rule_value, "condition", null)
          action = lookup(rule_value, "action", null)
          rule = lookup(rule_value, "rule", null)
          condition_key = condition
          }
        ]
      ]
    ]
  ])
  
  ###############
  # Default Listener Rules
  ###############
  forward_rules = local.forward_rules
  redirect_rules = local.redirect_rules
  fixed_response_rules = local.fixed_response_rules
  rule_conditions = local.rule_conditions

  ###############
  # Sercurity groups for ALB
  ###############
  
  sg_information = local.alb_sg_information
  ingress_cidr_rules = flatten([
    for sg_key, sg_value in local.alb_sg_information : [
      for ingress_key, ingress_value in sg_value.ingress_cidr_rules : {
        sg_key        = sg_key
        ingress_key   = ingress_key
        rules         = ingress_value.rules
        input_CIDR    = ingress_value.input_CIDR
        cidr_sg_value = ingress_value.cidr_sg_value
      }
    ]
  ])
  egress_cidr_rules = flatten([
    for sg_key, sg_value in local.alb_sg_information : [
      for egress_key, egress_value in sg_value.egress_cidr_rules : {
        sg_key        = sg_key
        egress_key    = egress_key
        rules         = egress_value.rules
        input_CIDR    = egress_value.input_CIDR
        cidr_sg_value = egress_value.cidr_sg_value
      }
    ]
  ])
  
  ###############
  # Depends_on
  ###############
  depends_on = [module.network]
  #depends_on = [module.network, module.security_group, module.ec2]
  
  ###############
  # Tags - Name
  ###############
  tags = {
    servicetitle          = local.tags.ServiceName
    env                   = local.tags.Environment
    aws_region_code       = local.aws_region_code
    creator               = local.alb_Creator
    operator1             = local.alb_Operator1
    operator2             = local.alb_Operator2
  }
}