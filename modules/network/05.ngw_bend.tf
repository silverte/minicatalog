#####################################################################
##  TemplateName:  05.ngw_bend.tf
##  Purpose:    Terraform Template for Public NAT Gateway
##  ---------------------------------------------------------------
##  Version  | Date        | Developer        | Update Reason
##  1.0    | 2022.03.11  | Hwang Gyu Yong  | First Version
##  1.1     | 2022.03.18    | Park Soo Min      | Modularization
#####################################################################

#####################################################################
##  Resource List
##  ---------------------------------------------------------------
##  EIP for Public NAT Gateway 
##  NAT Gateway 
#####################################################################
##  Input Variables
##  ------------------------------------------------------------------------------------------------------------------------
##  Variable for Creation   | Meaning                                | Type                              | from
##  ------------------------------------------------------------------------------------------------------------------------
##  var.vpc_id              | VPC ID                                 | String                            | ~modules/vpc/04.vpc.tf
##  var.aws_region          | AWS Region Name                        | String [default: ap-northeast-2]  | ~IaCTCL-dev/main.tf
##  var.aws_region_code     | AWS Region Code                        | String [default: an2]             | ~IaCTCL-dev/main.tf
##  local.snet_fend_a_id    | Resource ID of Public Subnet           | List(String)                      | 08.subnet_frontend.tf
##  var.azs                 | AWS Region Name(azs List)              | List(String)                      | ~IaCTCL-dev/main.tf
##  var.tags                | common tags                            | Map                               | ../../main/04.module_network.tf
#####################################################################
##  Output Variables
##  ------------------------------------------------------------------------------------------------------------------------
##  Variable for Output        | Meaning                                   | Type
##  ------------------------------------------------------------------------------------------------------------------------
##  local.eip_ngw_ids         | EIP for Public NAT Gateway                | List(String)
##  local.ngw_fend_ids        | Resource ID of Public NAT GW              | List(String)
##  ------------------------------------------------------------------------------------------------------------------------

##################################################################
# Resource Definition
##################################################################

################################################################################
# Public Subnet - frontend - EIP, NAT G/W
################################################################################
resource "aws_nat_gateway" "ngws_bend" {
  # count         = length(var.snet_fend_CIDR) > 0 ? length(var.snet_fend_CIDR) : 0
  for_each = {
    for key, value in var.subnet_INFO:
    key => value
    if (!(value.is_public) && value.is_ngw)
  }
  
  connectivity_type = "private"
  
  subnet_id     = aws_subnet.snets[each.key].id

  tags  = merge(var.tags, {
    Name      = "natgw-${var.tags.servicetitle}-${var.tags.env}-${var.tags.aws_region_code}-${each.key}"   # VPC Name
  })

  depends_on    = [aws_subnet.snets]
}

##################################################################
# Output
##################################################################
output "ngws_bend" {
    value = aws_nat_gateway.ngws_bend
}
