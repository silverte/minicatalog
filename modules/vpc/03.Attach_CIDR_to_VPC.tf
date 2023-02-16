#####################################################################
##  TemplateName:  03.Attach_CIDR_to_VPC.tf
##  Purpose:    Terraform Template for Attachment CIDRs to VPC
##  ---------------------------------------------------------------
##  Version  |  Date       |  Developer      | Update Reason
##  1.0      | 2022.03.11  | Hwang Gyu Yong  | First Version
##  1.1      | 2022.03.18  | Park Soo Min    | Modularization
#####################################################################

#####################################################################
##  Resource List                        | Name
##  ---------------------------------------------------------------
##  aws_vpc_ipv4_cidr_block_association  | addtional_cidr
#####################################################################
##  Input Variables
##  --------------------------------------------------------------------------------------
##  Variable for Creation                    | Meaning                | Type        | from
##  --------------------------------------------------------------------------------------
##  aws_vpc.default_vpc.id                   | VPC ID                | String      | ./02.vpc.tf
##  var.vpc_information.vpc_CIDR_Addtional   | Addtional CIDR List   | set(String) | ../../main/02.var_network.tf
#####################################################################
##  Output Variables
##  --------------------------------------------------------------------------------------
##  Variable for Output      | Meaning                | Type
##  --------------------------------------------------------------------------------------
##  --------------------------------------------------------------------------------------

################### Resource Definition ##########################
resource "aws_vpc_ipv4_cidr_block_association" "addtional_cidr" {
#  for_each = toset(var.vpc_CIDR_Addtional)
#  for_each = var.vpc_CIDR_Addtional
  for_each = var.vpc_information.vpc_CIDR_Addtional
#  vpc_id     = var.vpc_id
  vpc_id  = aws_vpc.default_vpc.id
  cidr_block = each.value
  
  depends_on  = [aws_vpc.default_vpc]
}
