#####################################################################
##  TemplateName:  03.module_vpc.tf
##  Purpose:    Create VPC
##  ---------------------------------------------------------------
##  Version  | Date        | Developer        | Update Reason
##  ---------------------------------------------------------------
##  1.0      | 2022.04.21  | Hwang Gyu Yong   | First Version
#####################################################################

#######################################################
## Create VPC
#######################################################

#####################################################################
##  Resource List                       | File path
##  ---------------------------------------------------------------
##  aws_vpc                             | ../modules/vpc/vpc.tf
##  aws_default_route_table             | ../modules/vpc/vpc.tf
##  aws_vpc_ipv4_cidr_block_association | ../modules/vpc/Attach_CIDR_to_VPC.tf
#####################################################################

################################################################################################################
##  Input Variables List
##  ------------------------------------------------------------------------------------------------------------
##  Variable Name                  |  Type     | dir path            | Meaning 
##  ------------------------------------------------------------------------------------------------------------
##  local.region                   | String    | ./var_common.tf     | AWS Region
##  local.aws_region_code          | String    | ./var_common.tf     | Code of AWS Region (abbreviation)
##  local.vpc_information          | object    | ./var_network.tf    | VPC informatiosn (default CIDR, Addtional CIDRs - if necessary, VPC Option - enable_dns_hostnames, VPC Option - enable_dns_support, VPC Option - instance_tenancy, Default = "default")
##  local.tags                     | Map       | ./var_common.tf     | Default Tag Information
##  local.tags.ServiceName         | String    | ./var_common.tf     | Service Title
##  local.tags.Environment         | String    | ./var_common.tf     | Environment of this system [prd | dev| stg | qa]
##  local.NW_Creator               | String    | ./var_network.tf    | Employee Number of Creator
##  local.NW_Operator1             | String    | ./var_network.tf    | Employee Number of Main Operator
##  local.NW_Operator2             | String    | ./var_network.tf    | Employee Number of Sub Operator
################################################################################################################

module "vpc" {
  ###############
  # Choose vpc module
  ###############
  source  = "../modules/vpc"

  ###############
  # Region
  ###############
  aws_region            = local.region
  aws_region_code       = local.aws_region_code

  ###############
  # Network - VPC Informations (CIDRs - Default & Addtional, VPC Options)
  ###############
  vpc_information       = local.vpc_information       # Setting VPC Informations

  ###############
  # Tags - SKT Common
  ###############
  #tags                  = local.tags

  ###############
  # Tags - Name
  ###############
  tags = {
    servicetitle          = local.tags.ServiceName
    env                   = local.tags.Environment
    aws_region_code       = local.aws_region_code
    creator               = local.NW_Creator
    operator1             = local.NW_Operator1
    operator2             = local.NW_Operator2
  }

}