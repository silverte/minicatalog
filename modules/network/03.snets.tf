#####################################################################
##  TemplateName:  03.subnet.tf
##  Purpose:    Terraform Template for Public Subnet
##  ---------------------------------------------------------------
##  Version  | Date        | Developer        | Update Reason
##  1.0      | 2022.03.11  | Hwang Gyu Yong  | First Version
##  1.1      | 2022.03.18  | Park Soo Min    | Modularization
#####################################################################

#####################################################################
##  Resource List                                             | Naming Rule
##  ---------------------------------------------------------------
##  aws_subnet                                                | "${var.prj_name}-${var.env}-${var.aws_region_code}-snet-${each.key}"
##  aws_route_table for each Subnet                           | "${var.prj_name}-${var.env}-${var.aws_region_code}-rt-${each.key}"
##  aws_route_table_association for each Subnet & Routetable  | Need not tag
#####################################################################
##  Input Variables
##  ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
##  Variable for Creation       | Meaning                                | Type                              | from
##  ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
##  var.subnet_INFO             | subnet Informations                    | Map                               | ./vars.tf (define), ../../main/02.var_network.tf (config)
##  var.vpc_id                  | VPC ID                                 | String                            | ../modules/vpc/04.vpc.tf
##  local.igw_id                | Internet Gateway ID                    | String                            | 07.igw.tf
##  var.aws_region              | AWS Region Name                        | String [default: ap-northeast-2]  | ~IaCTCL-dev/main.tf
##  var.aws_region_code         | AWS Region Code                        | String [default: an2]             | ~IaCTCL-dev/main.tf
##  var.user_code               | Creator Code (Employee No. of Creator) | String [XXXXX]                    | ~IaCTCL-dev/main.tf
##  var.map_public_ip_on_launch | VPC ID                                 | bool                              | ~modules/vpc/04.vpc.tf
##  var.azs                     | AWS Region Name(azs List)              | List(String)                      | ~IaCTCL-dev/main.tf
##  var.snet_fend_CIDR          | CIDR for Public Subnet                 | List(String)                      | ~IaCTCL-dev/main.tf
##  var.tags                    | common tags                            | Map                               | ../../main/04.module_network.tf
#####################################################################
##  Output Variables
##  ------------------------------------------------------------------------------------------------------------------------
##  Variable for Output      | Meaning                                       | Type
##  ------------------------------------------------------------------------------------------------------------------------
##  local.snet_fend_ids     | Resource ID of Public Subnet                  | List
##  local.rt_fend_ids       | Resource ID of Routetable for snet_fend_id    | List
##  ------------------------------------------------------------------------------------------------------------------------

##################################################################
# Resource Definition
##################################################################

################################################################################
# Publiс Subnet - frontend - uniq
################################################################################
resource "aws_subnet" "snets" {
  for_each                = var.subnet_INFO
  vpc_id                  = var.vpc_id
  availability_zone       = each.value.azs  # Availability Zone Information
  cidr_block              = each.value.snet_CIDR  # subnet CIDR
  map_public_ip_on_launch = false
  
  tags  = merge(var.tags, {
    Name = "snet-${var.tags.servicetitle}-${var.tags.env}-${var.tags.aws_region_code}-${each.key}-${each.value.snet_CIDR}"
    is-tgw  = "${each.value.is_tgw}"   #tgw-attach 에서 subnet ids 를 사용하기 위한 필터용 태그 추가 
    },
  (each.value.is_eks && each.value.is_public) ? {"kubernetes.io/role/elb" = "1"} : null,
  (each.value.is_eks && !each.value.is_public) ? {"kubernetes.io/role/internal-elb" = "1"} : null
  )
}

################################################################################
# frontend Route table, Association
################################################################################
resource "aws_route_table" "rtbs" {
  for_each  = var.subnet_INFO
  vpc_id    = var.vpc_id

  tags  = merge(var.tags, {
    Name = "rtb-${var.tags.servicetitle}-${var.tags.env}-${var.tags.aws_region_code}-${each.key}"
    })

}

# Routetable Association : Public Subnet A & Public Routetable A
resource "aws_route_table_association" "aws_rt_snet_fend_asso" {
  for_each  = aws_subnet.snets

  subnet_id = each.value.id
  route_table_id = aws_route_table.rtbs[each.key].id

  depends_on      = [aws_subnet.snets,aws_route_table.rtbs]
}

##################################################################
# Output
##################################################################
output "snets_ids" {
  description = "List of IDs of public subnets"
  value       = values(aws_subnet.snets)[*].id
}
output "rtbs_ids" {
  description = "List of IDs of public route tables"
  value       = values(aws_route_table.rtbs)[*].id
}

####################################
# Output for other modules
####################################
output "out_snets_info" {
  description = "map(any) of subnets raw info"
  value       = aws_subnet.snets
}

output "out_rtbs_info" {
  description = "map(any) of routetables raw info"
  value       = aws_route_table.rtbs
}