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
  for_each = var.vpc_information.vpc_CIDR_Addtional
  vpc_id  = aws_vpc.default_vpc.id
  cidr_block = each.value
  
  depends_on  = [aws_vpc.default_vpc]
}
