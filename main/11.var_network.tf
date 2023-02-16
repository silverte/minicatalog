#######################################################
## Variables for Network Resources
#######################################################

################################################################################################################
##  Variables List - Locals
##  ---------------------------------------------------------------
##  Variable Name                                |  Type     | Meaning 
##  ---------------------------------------------------------------
##  vpc_CIDR_default                             | String    | Default CIDR for VPC
##  vpc_CIDR_Addtional                           | List      | Additional CIDRs for VPC
##  enable_dns_hostnames                         | Boolean   | Option of VPC - enable dns hostname
##  enable_dns_support                           | Boolean   | Option of VPC - enable dns support 
##  instance_tenancy                             | Strig     | Config tenancy

##  vpc_information                              | object    | VPC Informations (default CIDR, Additional CIDRs, VPC Options)
##  vpc_information.vpc_CIDR_default             | String    | Default CIDR for VPC
##  vpc_information.vpc_CIDR_Addtional           | set(any)  | Additional CIDRs for VPC
##  vpc_information.enable_dns_hostnames         | bool      | Option of VPC - enable dns hostname
##  vpc_information.enable_dns_support           | bool      | Option of VPC - enable dns support 
##  vpc_information.instance_tenancy             | Strig     | Config tenancy
##  vpc_information.vpc_flowlog_arn              | Strig     | s3 arn of vpc flowlog 
##  subnet_information                           | Map       | Subnet informations ("key_name" = {Availability Zone, CIDR for Subnet, is it public?[true|false], need NAT gateway?[true,false], need to route public network?[true,false], need to route on-prem.?[true|false]})
##  subnet_information."key".azs                 | String    | Availability Zone of subnet
##  subnet_information."key".snet_CIDR           | String    | CIDR of subnet
##  subnet_information."key".is_public           | Boolean   | Type of subnet [true|false]
##  subnet_information."key".is_ngw              | Boolean   | usage status of NAT Gateway [true|false]
##  subnet_information."key".is_tgw              | Boolean   | usage status of Transit Gateway Attachment [true|false]
##  subnet_information."key".is_eks              | Boolean   | Subnet for EKS Cluster or not [true|false]
##  subnet_information."key".rt_to_internet      | Boolean   | need to route public network [true|false]
##  subnet_information."key".rt_to_priv_ngw      | Boolean   | need to route Private NAT Gateway [true|false] | Ether rt_to_priv_ngw or rt_to_tgw must be false
##  subnet_information."key".rt_to_tgw           | Boolean   | need to route Transit Gateway [true|false]     | Ether rt_to_priv_ngw or rt_to_tgw must be false
##  route_onprem_prefix_list                     | List      | On-Prem. CIDRs
##  route_lz_prefix_list                         | List      | On-Prem. CIDRs
##  tgw_id                                       | String    | Transit Gateway ID
##  tgw_conn                                     | boolean   | transit gateway 연결 여부 
##  NW_Creator                                   | String    | Employee Number of Creator for Network Resources
##  NW_Operator1                                 | String    | Employee Number of main Operator for Network Resources
##  NW_Operator2                                 | String    | Employee Number of sub Operator for Network Resources
################################################################################################################

#########################################
# Edit Variables
#########################################
locals {
  #############################################
  # Value for module.vpc, module.network
  #############################################

  ###############
  # VPC Informations - CIDRs & Options
  ###############
  # vpc_information = ({
  #   vpc_CIDR_default = "192.168.29.192/26"           # CIDR for public Subnet            ( 용도 : Public-Bastion, default )
  #   vpc_CIDR_Addtional    = [ 
  #                             "100.64.35.192/26",    # CIDR for snet_bend_uniq_CIDR  ( 용도 : )
  #                             "100.64.0.0/21",       # CIDR for snet_bend_dup_CIDR   ( 용도 : )
  #                             "192.168.29.160/27",   # CIDR for snet_bend_db_CIDR    ( 용도 : )
  #                           ]
  #   enable_dns_hostnames  = true                     # VPC Option - Enable DNS Hostname 활성화 여부
  #   enable_dns_support    = true                     # VPC Option - Enable DNS Support 활성화 여부
  #   instance_tenancy      = "default"                # VPC Option - instance tenancy 정보
  #   vpc_flowlog_arn       = "arn:aws:s3:::aws-vpcflow-logs-134236154053-ap-northeast-2/Parquet01"
  # })

    vpc_information = ({
    vpc_CIDR_default = "10.0.0.0/16"                 # CIDR
    vpc_CIDR_Addtional    = []
    enable_dns_hostnames  = true                     # VPC Option - Enable DNS Hostname 활성화 여부
    enable_dns_support    = true                     # VPC Option - Enable DNS Support 활성화 여부
    instance_tenancy      = "default"                # VPC Option - instance tenancy 정보
    vpc_flowlog_arn       = ""
  })
  
  subnet_information = {
    "public1-a" = {
      azs             = "${local.region}a"
      snet_CIDR       = "10.0.0.0/24"
      is_public       = true
      is_ngw          = true
      is_tgw          = false
      is_eks          = false
      rt_to_internet  = true
      rt_to_priv_ngw  = false
      rt_to_tgw       = false
    },
    "public2-c" = {
      azs             = "${local.region}c"
      snet_CIDR       = "10.0.1.0/24"
      is_public       = true
      is_ngw          = true
      is_tgw          = false
      is_eks          = false
      rt_to_internet  = true
      rt_to_priv_ngw  = false
      rt_to_tgw       = false
    },
    "private-db1-a" = {
      azs             = "${local.region}a"
      snet_CIDR       = "10.0.2.0/24"
      is_public       = false
      is_ngw          = false
      is_tgw          = false
      is_eks          = false
      rt_to_internet  = false
      rt_to_priv_ngw  = false
      rt_to_tgw       = false
    },
    "private-db2-c" = {
      azs             = "${local.region}c"
      snet_CIDR       = "10.0.3.0/24"
      is_public       = false
      is_ngw          = false
      is_tgw          = false
      is_eks          = false
      rt_to_internet  = false
      rt_to_priv_ngw  = false
      rt_to_tgw       = false
    },
    "private1-a" = {
      azs             = "${local.region}a"
      snet_CIDR       = "10.0.4.0/24"
      is_public       = false
      is_ngw          = false
      is_tgw          = false
      is_eks          = false
      rt_to_internet  = true
      rt_to_priv_ngw  = false
      rt_to_tgw       = false
    },
    "private2-c" = {
      azs             = "${local.region}c"
      snet_CIDR       = "10.0.5.0/24"
      is_public       = false
      is_ngw          = false
      is_tgw          = false
      is_eks          = false
      rt_to_internet  = true
      rt_to_priv_ngw  = false
      rt_to_tgw       = false
    }
    # },
    # "private-dup1-a" = {
    #   azs             = "${local.region}a"
    #   snet_CIDR       = "100.64.0.0/22"
    #   is_public       = false
    #   is_ngw          = false
    #   is_tgw          = false
    #   is_eks          = true
    #   rt_to_internet  = true
    #   rt_to_priv_ngw  = true
    #   rt_to_tgw       = false
    # },
    # "private-dup2-c" = {
    #   azs             = "${local.region}c"
    #   snet_CIDR       = "100.64.4.0/22"
    #   is_public       = false
    #   is_ngw          = false
    #   is_tgw          = false
    #   is_eks          = true
    #   rt_to_internet  = true
    #   rt_to_priv_ngw  = true
    #   rt_to_tgw       = false
    # }
  }

  ###############################
  # Route to On-Premise & Landing-Zone CIDR 
  ###############################
  # route_onprem_prefix_list     = [
  #                           "172.16.0.0/12",
  #                           "150.0.0.0/8",
  #                           "10.0.0.0/8",
  #                         ]
                          
  # route_lz_prefix_list     = [
  #                           "192.168.0.0/16",
  #                           "100.64.0.0/16",
  #                           "198.18.0.0/15"
  #                         ]

  route_onprem_prefix_list  = []                          
  route_lz_prefix_list      = []

  ###############
  # Transit Gateway ID of Cloud Landing Zone
  ###############
  # tgw_id    = "tgw-072d1d6d6eed05d14"  ## SKT Landing Zone
  # tgw_conn  = false

  tgw_id    = ""
  tgw_conn  = false
  
  ###############
  # Network Resources Creator & Operators
  ###############
  NW_Creator             = "07326"      # NW Resources creator
  NW_Operator1           = ""           # NW Resources operator1
  NW_Operator2           = ""           # NW Resources operator2
}
