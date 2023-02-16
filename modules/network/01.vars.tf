#######################################################
## Define Variables for Network Resources
#######################################################
## Resource List
##-----------------------------------------------------
## Internet Gateway
## Subnets
## Routetables
## aws_route_table_association
## EIPs
## NAT Gateways
## routes (routing rules)
#######################################################

################################################################################################################
##  List of Variables
##  ------------------------------------------------------------------------------------------------
##  Variable Name           | Type         | Meaning                                   | default
##  ------------------------------------------------------------------------------------------------
##  vpc_id                  | string       | vpc id                                    | ""
##  tags                    | map(string)  | default tags                              | {}
##  aws_region              | string       | aws region                                | ""
##  aws_region_code         | string       | aws region code                           | ""
##  map_public_ip_on_launch | bool         | configuration of map public ip on launch  | ""
##  subnet_INFO             | map(any)     | Information of subnets                    | ""
##  route_prefix_list       | list(string) | prefix lists for routing rule             | ""
##  tgw_id                  | string       | transit gateway id                        | ""

##  vpc_CIDR_default        | string       | VPC default CIDR                          | ""
##  vpc_CIDR_Addtional      | set(string)  | Additional CIDRs                          | ""
################################################################################################################

# Service Meta Data Definition 
variable "vpc_id" {
  description  =  "vpc_id for network resources"
  type    =  string
  default    =  ""
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "aws_region" {        # Region Code
  description  =  "aws region information (ex. ap-northeast-2)"
  type    =  string
  default    =  ""
}

variable "aws_region_code" {
  description  =  "region code (ex. an2)"
  type    =  string
  default    =  ""
}

# Configurations Definitions
variable "map_public_ip_on_launch" {
  description = "Should be false if you do not want to auto-assign public IP on launch"
  type        = bool
  default     = true
}

##################################
##  Network Configurations
##################################
# Subnets Informations
variable "subnet_INFO" {
  description  =  "Set of Subnet Information"
  type    =  map(any)
  default   =  {}
}

# Variable Type 변경 - list -> set
# https://medium.com/@jyson88/terraform-for-each-%EC%82%AC%EC%9A%A9-%EB%B0%A9%EB%B2%95-b225700625db
# count.index 사용시에는 변경안한 것들도 Update가 되버림 ( 1개만 삭제시, 변경하지 않은 나머지 N개까지 Update가 된다 )
# 그래서 for_each를 사용하기 위해 set(string)으로 변경.
variable "route_onprem_prefix_list" {
  type    = list(string)
  default = []
}

variable "route_lz_prefix_list" {
  type    = list(string)
  default = []
}

variable "route_all_prefix_list" {
  type    = list(string)
  default = []
}

variable "tgw_id" {
  type    = string
  default = null
}

variable "tgw_conn" {
  type    = bool
  default = false
}
