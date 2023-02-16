#####################################################################
##  Resource List              | Name
##  ---------------------------------------------------------------
##  aws_vpc                    | default_vpc
##  aws_default_route_table    | default_route_table
#####################################################################
##  Input Variables
##  ------------------------------------------------------------------------------------------------------------------------
##  Variable for Creation                    | Meaning                                 | Type                             | from
##  ------------------------------------------------------------------------------------------------------------------------
##  var.prj_name                             | Code of Project Name or Service Name     | String                           | ../../main/var_common.tf
##  var.env                                  | Environment of System                    | String [dev | stg | prd | qa]    | ../../main/var_common.tf
##  var.aws_region                           | AWS Region Name                          | String [default: ap-northeast-2] | ../../main/var_common.tf
##  var.aws_region_code                      | AWS Region Code                          | String [default: an2]            | ../../main/var_common.tf
##  var.creator                              | Creator Code (Employee No. of Creator)   | String [XXXXX]                   | ../../main/var_network.tf
##  var.operator1                            | Operator1 Code (Employee No. of Creator) | String [XXXXX]                   | ../../main/var_network.tf
##  var.operator2                            | Operator2 Code (Employee No. of Creator) | String [XXXXX]                   | ../../main/var_network.tf
##  var.vpc_information                      | Informations of VPC                      | object                           | ../../main/var_network.tf
##  var.vpc_information.vpc_CIDR_default     | Default CIDR for VPC                     | String [XXX.XXX.XXX.XXX/XX]      | ../../main/var_network.tf
##  var.vpc_information.instance_tenancy     | -                                        | String                           | ../../main/var_network.tf
##  var.vpc_information.enable_dns_hostnames | -                                        | bool                             | ../../main/var_network.tf
##  var.vpc_information.enable_dns_support   | -                                        | bool                             | ../../main/var_network.tf
##  var.tags                                 | common tags                              | Map                              | ../../main/03.module_vpc.tf
#####################################################################
##  Output Variables
##  ------------------------------------------------------------------------------------------------------------------------
##  Variable for Output         | Meaning                              | Type
##  ------------------------------------------------------------------------------------------------------------------------
##  out_vpc_info                | Informations of VPC                  | map(any)
##  out_default_routetable_info | Informations of default routetable   | map(any)
##  default_vpc_id              | ID of VPC created by terraform code  | String
##  default_route_table_id      | ID of default route table id         | String
##  default_network_acl_id      | ID of default ACL id                 | String
##  default_security_group_id   | ID of default Security Group id      | String
##  ------------------------------------------------------------------------------------------------------------------------

##################################################################
# Resource Definition
##################################################################

##################################################################
# Create VPC
##################################################################
resource "aws_vpc" "default_vpc" {

  cidr_block                       = var.vpc_information.vpc_CIDR_default         # Default CIDR Block
  instance_tenancy                 = var.vpc_information.instance_tenancy         # VPC Option - instance tenancy
  enable_dns_hostnames             = var.vpc_information.enable_dns_hostnames     # VPC Option - enable dns hostnames
  enable_dns_support               = var.vpc_information.enable_dns_support       # VPC Option - enable dns support

  tags  = merge(var.tags, {
    Name      = "vpc-${var.tags.servicetitle}-${var.tags.env}-${var.tags.aws_region_code}-nw"   # VPC Name
  })
}

##################################################################
# Create Default Route Table
##################################################################
resource "aws_default_route_table" "default_route_table" {
  default_route_table_id = aws_vpc.default_vpc.default_route_table_id

  tags  = merge(var.tags, {
  Name  = "rtb-${var.tags.servicetitle}-${var.tags.env}-${var.tags.aws_region_code}-default"   # Default route table name
  })
}

##################################################################
# Outputs for other module
##################################################################
output "out_vpc_info" {
  description = "map(any) of vpc raw informations"
  value = aws_vpc.default_vpc
}

output "out_default_routetable_info" {
  description = "map(any) of default routetable informations"
  value = aws_default_route_table.default_route_table
}

output "vpc_id" {
  description = "VPC ID"
  value = aws_vpc.default_vpc.id
}