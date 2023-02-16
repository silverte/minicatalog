#######################################################
## Requirements
## ----------------------------------------------------
## need hashicorp/aws version 4.0 later
#######################################################

################################################################################################################
##  Variables List - Locals
##  ------------------------------------------------------------------------------------------------------
##  Variable Name              |  Type     | Meaning                   | dir.path
##  ------------------------------------------------------------------------------------------------------
##  local.region               | String    | AWS Region                | ./01.var_common.tf
##  local.tags                 | String    | Default Tag Information   | ./01.var_common.tf
################################################################################################################

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  
#   backend "s3" {
#     bucket 			  = "s3-iac-pipeline-terraform-state"      #bucket name
#     key         	= "mctl-prd/infra-terraform.tfstate"     #bucket key 
#     region 				= "ap-northeast-3"                       #region 
#     encrypt 			= true                                   #encrypt yn 
#     dynamodb_table 	= "dydb-iac-pipeline-terraform-state"  #dynamodb table for locking
#     # role-arn           = "arn:aws:iam::875054318754:role/role-for-terraform-cross-account"
#   }
 }
provider "aws" {            ## Create Cloud Provider Object
  region  = local.region    ## Declear default region
  # profile = local.aws_profile
  # shared_credentials_files = ["/home/ec2-user/.aws/credentials"]  ## Configure Credential Inform

  default_tags {
    tags = local.tags
  }
}

##### 이 라인은 아래부터는 eks 를 사용하는 프로젝트의 경우만 활성화 한다. 
# data "aws_eks_cluster" "this" {
#     name = module.eks.eks_cluster.id
# }
# data "aws_eks_cluster_auth" "this" {
#     name = module.eks.eks_cluster.id
# }

# provider "helm" {
#   kubernetes {
#     host                   = data.aws_eks_cluster.this.endpoint
#     token                  = data.aws_eks_cluster_auth.this.token
#     cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
#   }
# }

# # aws-auth 를 위한 kubernetes provider 
# provider "kubernetes" {
#   host                   = data.aws_eks_cluster.this.endpoint
#   cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
#   token                  = data.aws_eks_cluster_auth.this.token
# }

#provider "kubernetes" {
#  host                   = data.aws_eks_cluster.this.endpoint
#  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
#
#  exec {
#    api_version = "client.authentication.k8s.io/v1beta1"
#    command     = "aws"
#    # This requires the awscli to be installed locally where Terraform is executed
#    args = ["eks", "get-token", "--cluster-name", module.eks.eks_cluster.id]
#  }
#}
