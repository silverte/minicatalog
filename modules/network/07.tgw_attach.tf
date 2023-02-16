#####################################################################
##  TemplateName:  07.tgw_attach.tf
##  Purpose:    Terraform Template for Transit gateway attachment
#####################################################################

#####################################################################
##  Resource List
##  ---------------------------------------------------------------
##  Transit gateway attachment
#####################################################################
##  Input Variables
##  ------------------------------------------------------------------------------------------------------------------------
##  Variable for Creation   | Meaning                                | Type                              | from
##  ------------------------------------------------------------------------------------------------------------------------
##  var.vpc_id              | VPC ID                                 | String                            | ~modules/vpc/04.vpc.tf
##  var.tgw_id              | Transit gateway ID of SKT L/Z          | String                            |  ../../main/02.var_network.tf (config)
##  var.subnet_INFO         | subnet Informations                    | Map                               | ./vars.tf (define),
##  var.azs                 | AWS Region Name(azs List)              | List(String)                      | ~IaCTCL-dev/main.tf
##  var.tags                | common tags                            | Map                               | ../../main/04.module_network.tf
#####################################################################
##  Output Variables
##  ------------------------------------------------------------------------------------------------------------------------
##  Variable for Output        | Meaning                                   | Type
##  ------------------------------------------------------------------------------------------------------------------------


locals {
    
    ## subnet list of transit gateway attachment
    tgw_subnet_id_list = [
        for key, value in var.subnet_INFO: {
            id = aws_subnet.snets[key]
        }
        if (value.is_tgw)
    ]
    
}

data "aws_subnets" "tgw_subnets" {
	filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  filter {
    name   = "tag:is-tgw"
    values = ["true"] # insert values here
  }
	depends_on        	= [aws_subnet.snets]
}

################################################################################
# Transit Gateway Attachment
################################################################################
resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attach" {

  count  = length(var.tgw_id) != 0 ? 1 : 0

  subnet_ids         = data.aws_subnets.tgw_subnets.ids #local.tgw_subnet_id_list
  transit_gateway_id = var.tgw_id
  vpc_id             = var.vpc_id
  depends_on        = [aws_subnet.snets]

  tags  = merge(var.tags, {
    Name      = "tgwat-${var.tags.servicetitle}-${var.tags.env}-${var.tags.aws_region_code}"   # VPC Name
  })
  
}

##################################################################
# Output
##################################################################
output "tgw_attach_id" {
    value = aws_ec2_transit_gateway_vpc_attachment.tgw_attach
}

