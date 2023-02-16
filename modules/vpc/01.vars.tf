#######################################################
## Define Variables for VPC
#######################################################
################################################################################################################
##  List of Variables
##  ------------------------------------------------------------------------------------------------------------------------
##  Variable Name                           | Type         | Meaning                                               | default
##  ------------------------------------------------------------------------------------------------------------------------
##  tags                                    | map(string)  | default tags                                          | {}
##  aws_region                              | string       | aws region                                            | ""
##  aws_region_code                         | string       | aws region code                                       | ""
##  vpc_information                         | object       | Informations of VPC                                   | 
##  vpc_information.vpc_CIDR_default        | string       | Value of Default VPC CIDR                             | "10.0.0.0/16"
##  vpc_information.vpc_CIDR_Addtional      | set(string)  | Values of Additional VPC CIDRs                        | []
##  vpc_information.instance_tenancy        | string       | A tenancy option for instances launched into the VPC  | "default"
##  vpc_information.enable_dns_hostnames    | bool         | Should be true to enable DNS hostnames in the VPC     | ""
##  vpc_information.enable_dns_support      | bool         | Should be true to enable DNS support in the VPC       | ""
################################################################################################################

# Service Meta Data 

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "aws_region" {        # Region Code
  description =  ""
  type        =  string
  default     =  ""
}

variable "aws_region_code" {
  description =  ""
  type        =  string
  default     =  ""
}

variable "vpc_information" {
  description = "Set of VPC Informations"
  type = object({
    vpc_CIDR_default = string           # CIDR for public Subnet            ( 용도 : Public-Bastion, default )
    vpc_CIDR_Addtional    = set(any)   # List of CIDRs
    enable_dns_hostnames  = bool
    enable_dns_support    = bool
    instance_tenancy      = string
    vpc_flowlog_arn       = string
  })
  default = {
    vpc_CIDR_default =  "10.0.0.0/16"           # CIDR for public Subnet            ( 용도 : Public-Bastion, default )
    vpc_CIDR_Addtional    = []   # List of CIDRs
    enable_dns_hostnames  = true
    enable_dns_support    = true
    instance_tenancy      = "default"
    vpc_flowlog_arn       = ""
  }
}
