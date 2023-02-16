#######################################################
## Create Network Resources
#######################################################

#####################################################################
##  Resource List                       | File path
##  ---------------------------------------------------------------
##  aws_internet_gateway                | ../modules/network/igw.tf
##  aws_subnet                          | ../modules/network/snets.tf
##  aws_eip                             | ../modules/network/04.eip_ngw_fend.tf
##  aws_nat_gateway(Public NGW)         | ../modules/network/04.eip_ngw_fend.tf
##  aws_nat_gateway(Private NGW)        | ../modules/network/05.ngw_bend.tf
##  aws_ec2_managed_prefix_list         | ../modules/network/06.route_rule.tf
##  aws_ec2_managed_prefix_list_entry   | ../modules/network/06.route_rule.tf
##  aws_route(route_to_igw)             | ../modules/network/06.route_rule.tf
##  aws_route(route_to_pub_ngw)         | ../modules/network/06.route_rule.tf
##  aws_route(route_to_pri_ngw)         | ../modules/network/06.route_rule.tf
##  aws_route(route_to_tgw)             | ../modules/network/06.route_rule.tf
#####################################################################

################################################################################################################
##  Input Variables List
##  ------------------------------------------------------------------------------------------------------------
##  Variable Name                  |  Type     | dir path            | Meaning 
##  ------------------------------------------------------------------------------------------------------------
##  local.region                   | String    | ./var_common.tf     | AWS Region
##  local.aws_region_code          | String    | ./var_common.tf     | Code of AWS Region (abbreviation)
##  module.vpc.vpc_id              | String    | ./module_vpc.tf     | VPC ID - Mandatory
##  local.subnet_information       | Map       | ./var_network.tf    | Subnet Informations
##  local.tgw_id                   | String    | ./var_network.tf    | Transit Gateway ID
##  local.route_prefix_list        | List      | ./var_network.tf    | List of route prefix values for On-Prem. routing
##  local.tags                     | Map       | ./var_common.tf     | Default Tag Information
##  local.tags.ServiceName         | String    | ./var_common.tf     | Service Title
##  local.tags.Environment         | String    | ./var_common.tf     | Environment of this system [prd | dev| stg | qa]
##  local.NW_Creator               | String    | ./var_network.tf    | Employee Number of Creator
##  local.NW_Operator1             | String    | ./var_network.tf    | Employee Number of Main Operator
##  local.NW_Operator2             | String    | ./var_network.tf    | Employee Number of Sub Operator
################################################################################################################

module "network" {
  ###############
  # Choose network module
  ###############
  source  = "../modules/network"

  ###############
  # Region
  ###############
  aws_region            = local.region
  aws_region_code       = local.aws_region_code

  ###############
  # Module Output
  ###############
  vpc_id                = module.vpc.vpc_id      # vpc 생성 후 vpc id 값을 저장

  ###############
  # Subnet
  ###############
  subnet_INFO           = local.subnet_information

  ##############################
  # Config Transit Gateway ID
  ##############################
  #tgw_id = length(local.tgw_id == 0) ? null : local.tgw_id
  tgw_id = local.tgw_id
  tgw_conn = local.tgw_conn

  ###############
  # Route Rules to On-Premise
  ###############
  route_onprem_prefix_list     = local.route_onprem_prefix_list
  route_lz_prefix_list     = local.route_lz_prefix_list
  route_all_prefix_list     = concat(local.route_onprem_prefix_list, local.route_lz_prefix_list)
  
  ###############
  # Options
  ###############
  map_public_ip_on_launch = false
  
  ###############
  # Depends_on
  ###############
  depends_on = [module.vpc]
  
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
