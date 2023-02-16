#####################################################################
##  TemplateName:  06.route_rule.tf
##  Purpose:    Terraform Template for Routing Rules
##  ---------------------------------------------------------------
##  Version | Date        | Developer       | Update Reason
##  1.0     | 2022.03.11  | Hwang Gyu Yong  | First Version
##  1.1     | 2022.03.18  | Park Soo Min    | Modularization
##  1.2     | 2022.05.26  | Kim Beom Gyu    | Modify route logic
#####################################################################

#####################################################################
##  Resource List                         | Define Name
##  ---------------------------------------------------------------
##  aws_route                             | route_to_igw
##  aws_route                             | route_to_pub_ngw
##  aws_route                             | route_to_pri_ngw_all
##  aws_route                             | route_to_pri_ngw_onprem
##  aws_route                             | route_to_tgw_all
##  aws_route                             | route_to_tgw_lz
#####################################################################
##  Input Variables
##  ------------------------------------------------------------------------------------------------------------------------
##  Variable for Creation       | Meaning                                     | Type                              | from
##  ------------------------------------------------------------------------------------------------------------------------
##  var.aws_region_code         | AWS Region Code                             | String [default: an2]             | ../../main/01.var_common.tf
##  var.subnet_INFO             | subnet Informations                         | Map                               | ./vars.tf (define),
##                                                                                                                | ../../main/02.var_network.tf (config)
##  var.subnet_INFO.is_public   | Attribute of Subnets(public / private)      | Bool [ true | false ]             | ../../main/02.var_network.tf (config)
##  var.subnet_INFO.is_ngw      | Attribute of Subnets(ngw existence)         | Bool [ true | false ]             | ../../main/02.var_network.tf (config)
##  var.tgw_id                  | Transit Gateway ID for on-prem. interfacing | String                            | ../../main/02.var_network.tf (config)
#####################################################################
##  Local Variables           | Type   | meaning                                                                  | origin variable
##  ------------------------------------------------------------------------------------------------------------------------
##  pub_rt_subnet_list        | set    | information of private subnets need outbound routing for internet        | var.subnet_INFO
##  priv_ngw_rt_subnet_list   | set    | information of subnets need outbound routing for private nat gateway     | var.subnet_INFO
##  tgw_rt_subnet_list        | set    | information of subnets need outbound routing for transit gateway         | var.subnet_INFO
##  pub_ngw_key_list          | set    | information of subnets contain Public NAT Gateway                        | var.subnet_INFO
##  priv_ngw_key_list         | set    | information of subnets contain Private NAT Gateway                       | var.subnet_INFO
##  pair_pub_ngw_rt           | set    | setproduct(local.pub_rt_subnet_list, local.pub_ngw_key_list)             | local.pub_rt_subnet_list, local.pub_ngw_key_list
##  pair_pri_ngw_rt           | set    | setproduct(local.priv_ngw_rt_subnet_list, local.priv_ngw_key_list)       | local.priv_ngw_rt_subnet_list, local.priv_ngw_key_list
##  pri_ngw_rt_all_prefix     | set    | setproduct(local.pair_pri_ngw_rt, toset(var.route_all_prefix_list)   )   | local.pair_pri_ngw_rt, var.route_onprem_prefix_list
##  pri_ngw_rt_onprem_prefix  | set    | setproduct(local.pair_pri_ngw_rt, toset(var.route_onprem_prefix_list))   | local.tgw_rt_subnet_list, var.route_all_prefix_list
##  tgw_rt_all_prefix         | set    | setproduct(local.tgw_rt_subnet_list, toset(var.route_all_prefix_list))   | local.tgw_rt_subnet_list, var.route_all_prefix_list
##  tgw_rt_lz_prefix          | set    | setproduct(local.tgw_rt_subnet_list, toset(var.route_lz_prefix_list))    | local.tgw_rt_subnet_list, var.route_lz_prefix_list
#####################################################################
##  Output Variables
##  ------------------------------------------------------------------------------------------------------------------------
##  Variable for Output            | Meaning                                                 | Type
##  ------------------------------------------------------------------------------------------------------------------------
##  out_prefix_list_info           | map(any) of prefix list for Interfacing On-Prem. CIDRs  | map
##  out_route_igw_info             | map(any) of routing forward Internet Gateway            | map
##  out_route_pubngw_info          | map(any) of routing forward Public NAT Gateway          | map
##  out_route_pringw_all_info      | map(any) of routing forward Private NAT Gateway         | map
##  out_route_pringw_onprem_info   | map(any) of routing forward Private NAT Gateway         | map
##  out_route_tgw_all_info         | map(any) of routing forward Transit Gateway             | map
##  out_route_tgw_lz_info          | map(any) of routing forward Transit Gateway             | map
##  ------------------------------------------------------------------------------------------------------------------------

##################################################################
# Variables Definition
##################################################################

locals {
    ## subnet list need to routing public ngw
    pub_rt_subnet_list = [
        for key, value in var.subnet_INFO: {
            key = key
            azs = value.azs
            is_public = value.is_public
            is_ngw = value.is_ngw
#            rt_to_internet_bool = value.rt_to_internet_bool
            rt_to_internet = value.rt_to_internet
#            rt_to_onprem_bool = value.rt_to_onprem_bool
            rt_to_priv_ngw = value.rt_to_priv_ngw
            rt_to_tgw = value.rt_to_tgw
        }
#        if (!value.is_public && value.rt_to_internet_bool)
        if (!value.is_public && value.rt_to_internet)
    ]
    
    ## subnet list need to routing private ngw
    priv_ngw_rt_subnet_list = [
        for key, value in var.subnet_INFO: {
            key = key
            azs = value.azs
            is_public = value.is_public
            is_ngw = value.is_ngw
            is_tgw = value.is_tgw
            rt_to_internet = value.rt_to_internet
            rt_to_priv_ngw = value.rt_to_priv_ngw
            rt_to_tgw = value.rt_to_tgw
        }
        if (!(!value.is_public && value.is_ngw) && value.rt_to_priv_ngw)
        #if (value.rt_to_priv_ngw)
    ]
    
    ## subnet list need to routing transit gw
    tgw_rt_subnet_list = [
        for key, value in var.subnet_INFO: {
            key = key
            azs = value.azs
            is_public = value.is_public
            is_ngw = value.is_ngw
            is_tgw = value.is_tgw
            rt_to_internet = value.rt_to_internet
            rt_to_priv_ngw = value.rt_to_priv_ngw
            rt_to_tgw = value.rt_to_tgw
        }
        if (length(var.tgw_id) != 0 && value.rt_to_tgw)
    ]
    
    ## public ngw key list
    pub_ngw_key_list = [
        for key, value in var.subnet_INFO: {
            key = key
            is_public = value.is_public
            azs = value.azs
        }
        if (value.is_ngw && value.is_public)
    ]
    
    ## private ngw key list
    priv_ngw_key_list = [
        for key, value in var.subnet_INFO: {
            key = key
            is_public = value.is_public
            azs = value.azs
        }
        if (value.is_ngw && !value.is_public)
    ]
    
    ## cartetian product with pub_ngw_rt_subnet_list & pub_ngw_key_list
    pair_pub_ngw_rt = [
        for pair in setproduct(local.pub_rt_subnet_list, local.pub_ngw_key_list): {
            key = pair[0].key
            azs = pair[0].azs
            is_public = pair[0].is_public
            is_ngw = pair[0].is_ngw
            ngw_key = pair[1].key
        }
        if ((length(local.pub_ngw_key_list) > 1 ? pair[0].azs == pair[1].azs : true) && pair[1].is_public)
    ]
    
    ## cartetian product with priv_ngw_rt_subnet_list & priv_ngw_key_list
    pair_pri_ngw_rt = [
        for pair in setproduct(local.priv_ngw_rt_subnet_list, local.priv_ngw_key_list): {
            key = pair[0].key
            azs = pair[0].azs
            is_public = pair[0].is_public
            is_ngw = pair[0].is_ngw
            is_tgw = pair[0].is_tgw
            ngw_key = pair[1].key
            rt_to_tgw = pair[0].rt_to_tgw
        }
        if ((length(local.priv_ngw_key_list) > 1 ? pair[0].azs == pair[1].azs : true) && !pair[1].is_public)
    ]

    ## cartetian product with pair_pri_ngw_rt & route_all_prefix_list
    ## backend-dup > private nat gw > transit gateway (destination : all prefix)
    pri_ngw_rt_all_prefix = [
      for prefix in setproduct(local.pair_pri_ngw_rt, toset(var.route_all_prefix_list)) : {
        key = "${prefix[0].key}.${prefix[0].ngw_key}.${prefix[1]}"
        subnet_key = prefix[0].key
        ngw_key = prefix[0].ngw_key
        is_public = prefix[0].is_public
        is_ngw = prefix[0].is_ngw
        is_tgw = prefix[0].is_tgw
        rt_to_tgw = prefix[0].rt_to_tgw
        cidr_block = prefix[1]
      }
      if (!prefix[0].rt_to_tgw && !prefix[0].is_public)
    ]

    ## cartetian product with pair_pri_ngw_rt & route_onprem_prefix_list
    ## frontend, backend-db > private nat gw > transit gateway (destination : onprem prefix)
    pri_ngw_rt_onprem_prefix = [
      for prefix in setproduct(local.pair_pri_ngw_rt, toset(var.route_onprem_prefix_list)) : {
        key = "${prefix[0].key}.${prefix[0].ngw_key}.${prefix[1]}"
        subnet_key = prefix[0].key
        ngw_key = prefix[0].ngw_key
        is_public = prefix[0].is_public
        is_ngw = prefix[0].is_ngw
        is_tgw = prefix[0].is_tgw
        cidr_block = prefix[1]
      }
      if (prefix[0].rt_to_tgw)
    ]   
    
    ## cartetian product with tgw_rt_subnet_list & route_all_prefix_list
    ## backend-uniq > transit gateway (destination : all prefix)
    tgw_rt_all_prefix = [
      for prefix in setproduct(local.tgw_rt_subnet_list, toset(var.route_all_prefix_list)) : {
        key = "${prefix[0].key}.${prefix[1]}"
        subnet_key = prefix[0].key
        is_public = prefix[0].is_public
        is_ngw = prefix[0].is_ngw
        is_tgw = prefix[0].is_tgw
        cidr_block = prefix[1]
      }
      if (prefix[0].is_tgw)
    ]
    
    ## cartetian product with tgw_rt_subnet_list & route_all_prefix_list
    ## frontend, backend-db > transit gateway (destination : landing zone prefix)
    tgw_rt_lz_prefix = [
      for prefix in setproduct(local.tgw_rt_subnet_list, toset(var.route_lz_prefix_list)) : {
        key = "${prefix[0].key}.${prefix[1]}"
        subnet_key = prefix[0].key
        is_public = prefix[0].is_public
        is_ngw = prefix[0].is_ngw
        is_tgw = prefix[0].is_tgw
        cidr_block = prefix[1]
      }
      if (!prefix[0].is_tgw)
    ]
    
}

data "aws_ec2_transit_gateway" "tgw_on_prem" {
    count = length("${var.tgw_id}")
    id = "${var.tgw_id}"
}


#################################################################################################################
## Route Rules
#################################################################################################################
## 1st) Route for Internet Gateway
## 2nd) Route for Public NAT Gateway - Internet
## 3rd) Route for Private NAT Gateway - On-Premise 
## 4th) Route for Transit Gateway - On-Premise
#########################################################
# 1st) Add route information to routetables - Public Subnet to Internet Gateway
resource "aws_route" "route_to_igw" {
    for_each = {
        for key, value in var.subnet_INFO:
        key => value
        if (value.is_public)
    }
    
    route_table_id          = aws_route_table.rtbs[each.key].id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id          	= aws_internet_gateway.default_igw.id

 	depends_on              = [aws_route_table.rtbs,aws_internet_gateway.default_igw]
}

# 2nd) Add route information to routetables - Private Subnet to Public NAT Gateway
# Must Edit ==> depends_on 살려야함.

resource "aws_route" "route_to_pub_ngw" {
    for_each = {
        for pair_ngw_rt in local.pair_pub_ngw_rt: "${pair_ngw_rt.key}.${pair_ngw_rt.ngw_key}" => pair_ngw_rt
    }
    
    route_table_id          = aws_route_table.rtbs[each.value.key].id
    destination_cidr_block = "0.0.0.0/0"

    nat_gateway_id          = aws_nat_gateway.ngws_fend[each.value.ngw_key].id
 	depends_on              = [aws_route_table.rtbs,aws_nat_gateway.ngws_fend]
}

# 3rd) Add route information to routetables - to Private NAT G/W (in Private Subnet)
resource "aws_route" "route_to_pri_ngw_all" {

    for_each = {
        for pair_ngw_rt in local.pri_ngw_rt_all_prefix: pair_ngw_rt.key => pair_ngw_rt
    }
    route_table_id          = aws_route_table.rtbs[each.value.subnet_key].id

    destination_cidr_block = each.value.cidr_block

 	nat_gateway_id          = aws_nat_gateway.ngws_bend[each.value.ngw_key].id

 	depends_on              = [aws_route_table.rtbs,aws_nat_gateway.ngws_bend] #,aws_ec2_managed_prefix_list.route_to_onpremise]
}

# 4th) Add route information to routetables - to Private NAT G/W (in Private Subnet)
resource "aws_route" "route_to_pri_ngw_onprem" {

    for_each = {
        for pair_ngw_rt in local.pri_ngw_rt_onprem_prefix: pair_ngw_rt.key => pair_ngw_rt
    }
    route_table_id          = aws_route_table.rtbs[each.value.subnet_key].id

    destination_cidr_block = each.value.cidr_block

 	nat_gateway_id          = aws_nat_gateway.ngws_bend[each.value.ngw_key].id

 	depends_on              = [aws_route_table.rtbs,aws_nat_gateway.ngws_bend] #,aws_ec2_managed_prefix_list.route_to_onpremise]
}

# 5th) Add route information to routetables - to Transit G/W (in Private Subnet)
resource "aws_route" "route_to_tgw_all" {

    for_each = {
        for tgw_rt in local.tgw_rt_all_prefix: tgw_rt.key => tgw_rt
            if ( var.tgw_conn )
    }
    route_table_id          = aws_route_table.rtbs[each.value.subnet_key].id

 	destination_cidr_block = each.value.cidr_block
    transit_gateway_id      = "${var.tgw_id}"

 	depends_on              = [aws_route_table.rtbs,aws_ec2_transit_gateway_vpc_attachment.tgw_attach] 
}

# 6th) Add route information to routetables - to Transit G/W (in Private Subnet)
resource "aws_route" "route_to_tgw_lz" {

    for_each = {
        for tgw_rt in local.tgw_rt_lz_prefix: tgw_rt.key => tgw_rt
            if ( var.tgw_conn )
#        if length(data.aws_ec2_transit_gateway.tgw_on_prem) != 0
    }
    route_table_id          = aws_route_table.rtbs[each.value.subnet_key].id
 	destination_cidr_block = each.value.cidr_block
    transit_gateway_id      = "${var.tgw_id}"

 	depends_on              = [aws_route_table.rtbs,aws_ec2_transit_gateway_vpc_attachment.tgw_attach] 
}

##################################################################
# Outputs
##################################################################


output "out_route_igw_info" {
    description = "map(any) of routing forward Internet Gateway"
    value = aws_route.route_to_igw
}

output "out_route_pubngw_info" {
    description = "map(any) of routing forward public NAT Gateway"
    value = aws_route.route_to_pub_ngw
}

output "out_route_pringw_all_info" {
    description = "map(any) of routing forward private NAT Gateway"
    value = aws_route.route_to_pri_ngw_all
}

output "out_route_pringw_onprem_info" {
    description = "map(any) of routing forward private NAT Gateway"
    value = aws_route.route_to_pri_ngw_onprem
}

output "out_route_tgw_all_info" {
    description = "map(any) of routing forward Transit Gateway"
    value = aws_route.route_to_tgw_all
}

output "out_route_tgw_lz_info" {
    description = "map(any) of routing forward Transit Gateway"
    value = aws_route.route_to_tgw_lz
}
