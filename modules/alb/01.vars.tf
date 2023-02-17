#######################################################
## Define Variables for ALB
#######################################################

################################################################################################################
##  List of Variables
##  ------------------------------------------------------------------------------------------------
##  Variable Name             | Type                 | Meaning                                   | default
##  ------------------------------------------------------------------------------------------------
##  vpc_id                    | string               | vpc id                                    | ""
##  tags                      | map(string)          | default tags                              | {}
##  aws_region                | string               | aws region                                | ""
##  aws_region_code           | string               | aws region code                           | ""
##  snets_info                | map(any)             | Information of subnets                    | {}
##  application_loadbalancer  | map(any)             | Information of alb                        | {}
##  alb_listener              | List of object(any)  | flattened list of listeners               | []
##  alb_rule                  | List of object(any)  | flattened list of rules                   | []
##  alb_rule_condition        | List of object(any)  | flattened list of rule conditions         | []
##  forward_rules             | map(any)             | Information of target groups              | {}
##  nlb_target_list           | List of object(any)  | flattened list of target                  | []
##  redirect_rules            | map(any)             | Information of redirect rules             | {}
##  fixed_response_rules      | map(any)             | Information of fixed-response rules       | {}
##  rule_conditions           | map(any)             | Information of rule conditions            | {}
##  sg_information            | map(any)             | Information of security groups            | {}
##  ingress_cidr_rules        | list(any)            | sg rules for ingress                      | []
##  egress_cidr_rules         | list(any)            | sg rules for egress                       | []
################################################################################################################

variable "vpc_id" {
  description = "vpc_id for network resources"
  type        = string
  default     = ""
}

variable "aws_region" { # Region Code
  description = "aws region information (ex. ap-northeast-2)"
  type        = string
  default     = ""
}

variable "aws_region_code" {
  description = "region code (ex. an2)"
  type        = string
  default     = ""
}

variable "snets_info" {
  description = "snets_id for network resources"
  type        = map(any)
  default     = {}
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "application_loadbalancer" {
  description = ""
  type        = map(any)
  default     = {}
}

variable "alb_listener" {
  description = ""
  type        = list(any)
  default     = []
}

variable "alb_rule" {
  description = ""
  type        = list(any)
  default     = []
}

variable "alb_rule_condition" {
  description = ""
  type        = list(any)
  default     = []
}

variable "alb_target_list" {
  description = ""
  type        = list(any)
  default     = []
}

variable "forward_rules" {
  description = ""
  type        = map(any)
  default     = {}
}

variable "redirect_rules" {
  description = ""
  type        = map(any)
  default     = {}
}

variable "fixed_response_rules" {
  description = ""
  type        = map(any)
  default     = {}
}

variable "rule_conditions" {
  description = ""
  type        = any
  default     = []
}

##########################################
######## Security Group Variable #########
##########################################

variable "sg_information" {
  description  =  ""
  type    =  map(any)
  default   =  {}
}
variable "ingress_cidr_rules" {
  description = ""
  type        = list(any)
  default     = []
}
variable "egress_cidr_rules" {
  description = ""
  type        = list(any)
  default     = []
}