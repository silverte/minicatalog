#####################################################################
##  TemplateName:  02.igw.tf
##  Purpose:    Terraform Template for Internet Gateway
##  ---------------------------------------------------------------
##  Version | Date        | Developer       | Update Reason
##  1.0     | 2022.03.11  | Hwang Gyu Yong  | First Version
##  1.1     | 2022.03.18  | Park Soo Min    | Modularization
#####################################################################

#####################################################################
##  Resource List                 | Naming Rule
##  ---------------------------------------------------------------
##  aws_internet_gateway          | ${var.prj_name}-${var.env}-${var.aws_region_code}-igw
#####################################################################
##  Input Variables
##  ------------------------------------------------------------------------------------------------------------------------
##  Variable for Creation   | Meaning                                  | Type                              | from
##  ------------------------------------------------------------------------------------------------------------------------
##  var.vpc_id              | VPC ID                                   | String                            | ../vpc/02.vpc.tf
##  var.aws_region          | AWS Region Name                          | String [default: ""]              | ../../main/02.var_network.tf
##  var.aws_region_code     | AWS Region Code                          | String [default: ""]              | ../../main/02.var_network.tf
##  var.tags                | common tags                              | Map                               | ../../main/04.module_network.tf
#####################################################################
##  Output Variables
##  ------------------------------------------------------------------------------------------------------------------------
##  Variable for Output     | Meaning                                      | Type
##  ------------------------------------------------------------------------------------------------------------------------
##  default_igw_id          | -                                            | String
##  out_igw_info            | map(any) of Internet Gateway raw information | map
##  ------------------------------------------------------------------------------------------------------------------------

##################################################################
# Resource Definition
##################################################################

##################################################################
# Internet Gateway
##################################################################
resource "aws_internet_gateway" "default_igw" {
  vpc_id = var.vpc_id                         # module.vpc.vpc_id로 대체 가능?

  tags  = merge(var.tags, {
    Name      = "igw-${var.tags.servicetitle}-${var.tags.env}-${var.tags.aws_region_code}-nw"   # VPC Name
  })
  
}

##################################################################
# Output
##################################################################
output "default_igw_id" {
  value = aws_internet_gateway.default_igw.id
}

output "out_igw_info" {
  description = "map(any) of Internet Gateway raw information"
  value = aws_internet_gateway.default_igw
}