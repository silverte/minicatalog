#######################################################
## Common Variables - Service Meta data & Default Tags
#######################################################

################################################################################################################
##  Variables List - Locals
##  ---------------------------------------------------------------
##  Variable Name              |  Type     | Meaning 
##  ---------------------------------------------------------------
##  region                     | String    | AWS Region
##  aws_region_code            | String    | Code of AWS Region (abbreviation)
##  tags                       | Set       | Default Tags (if you want to add Service Information, add here)
##  tags.ServiceName           | String    | Name of Service
##  tags.Environment           | String    | Type of Environment ([dev|stg|prd])
##  tags.Personalinformation   | String    | Does this system has personal information? ([yes|no])
################################################################################################################

#########################################
# Edit Variables
#########################################
locals {
  #############################################
  # Value for All resources
  #############################################

  ###############
  # Region
  ###############
  region          = "ap-northeast-3" # Region
  aws_region_code = "an3"            # Region Alias
  aws_profile     = "default"          # 미리 aws configure 수행해둘것
  #aws_profile     = "AWSAdministrator-135665410084"          # 미리 aws configure 수행해둘것

  ###############
  # Common Tags
  ###############
  tags = {
    ServiceName         = "mctl" # Service Name
    Environment         = "prd"  # prd/stg/dev
    Personalinformation = "no"   # yes / no
  }

}
