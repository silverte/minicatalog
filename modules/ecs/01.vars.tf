##############################
# ECS Cluster 설정
##############################  
variable "ECS_Cluster_Info" {
    description =  ""
    type        =  map(any)
    default     =  {}
}

variable "ECS_LB_Subnets" {
    description =  ""
    type        =  set(string)
    default     =  []
}

variable "ECS_Inst_Subnets" {
    description =  ""
    type        =  set(string)
    default     =  []
}

variable "DBMS_Inst_Subnets" {
    description =  ""
    type        =  set(string)
    default     =  []
}

##############################
# ECS 운영자 설정
##############################
variable "ECS_operator_ip" {
    description =  ""
    type        =  list(string)
    default     =  []
}

variable "ECS_key_pair" {
    description = "ECS_Remote_ec2_key_pair"
    type        =  map(any)
    default     =  {}
}

variable "ECS_key_pair_name" {
    description = "ECS_Remote_ec2_key_pair"
    type        =  string
    default     =  ""
}

##############################
# ECS Sample 설정
##############################
variable "ECS_Sample" {
    description =  ""
    type        =  map(any)
    default     =  {}
}

##############################
# Output Info ( module.vpc / module.network )
##############################
variable "vpc_id" {
    description =  ""
    type        =  string
    default     =  ""
}

variable "out_snets_info" {
    description = ""
    type        = map(any)
    default     = {}
}

variable "alb_tgr_arn" {
    description = ""
    type = string
    default = ""
}

##############################
# Tags - ECS 운영자 사번
##############################
variable "creator" {
    description =  ""
    type        =  string
    default     =  ""
}

variable "operator1" {
    description =  ""
    type        =  string
    default     =  ""
}

variable "operator2" {
    description =  ""
    type        =  string
    default     =  ""
}

##############################
# 공통 설정 - ( 01.var_common.tf )
##############################
variable "aws_region" {        # Region Code
    description =  ""
    type        =  string
    default     =  ""
}

variable "aws_region_code" {
    description =  ""
    type        =  string
    default     =  ""
}

variable "aws_profile" {
    description =  ""
    type        =  string
    default     =  ""
}

##############################
# 공통 설정 - Tag
##############################
variable "tags" {
    description = "A map of tags to add to all resources"
    type        = map(string)
    default     = {}
}

variable "servicetitle" {
    description =  ""
    type        =  string
    default     =  ""
}

variable "environment" {
    description =  ""
    type        =  string
    default     =  ""
}

variable "personalinformation" {
    description =  ""
    type        =  string
    default     =  ""
}