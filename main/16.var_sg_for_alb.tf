#####################################################################
##  TemplateName:  24.var_sg_for_alb.tf
##  Purpose:    Define Variables for Security groups of Application load balancer
#####################################################################

#######################################################
## Variables for Security groups of Application Loadbalancer
#######################################################

################################################################################################################
##  Variables List - Locals
##  ---------------------------------------------------------------
##  Variable Name                                                |  Type        | Meaning 
##  ---------------------------------------------------------------
##  alb_sg_information                                           | Map          | All security groups
##  alb_sg_information."key".description                         | string       | description of sg
##  alb_sg_information."key".ingress_cidr_rules                  | Map          | map of ingress cidr rules
##   ..ingress_cidr_rules."key".rules                            | list         | ['from port', 'to port', 'protocol', 'description']
##   ..ingress_cidr_rules."key".input_CIDR                       | boolean      | Type of cidr_sg_value ('true' for CIDR / 'false' for other sg)
##  alb_sg_information."key".egress_cidr_rules                   | Map          | map of egress cidr rules
##   ..egress_cidr_rules."key".rules                             | list         | ['from port', 'to port', 'protocol', 'description']
##   ..egress_cidr_rules."key".input_CIDR                        | boolean      | Type of cidr_sg_value ('true' for CIDR / 'false' for other sg)

#########################################
# Edit Variables
#########################################

locals {

  alb_sg_information = {
  
  # "internal-alb" = {
  #     description = "sg for private zone_alb"
  #     ingress_cidr_rules = {
  #       "ingress_1" = {
  #         rules         = [80, 80, "tcp", "internal users"]
  #         input_CIDR    = true
  #         cidr_sg_value = ["150.0.0.0/8","172.26.0.0/16","172.16.95.241/32"]
  #       }
        
  #       "ingress_2" = {
  #         rules         = [443, 443, "tcp", "internal users"]
  #         input_CIDR    = true
  #         cidr_sg_value = ["150.0.0.0/8","172.26.0.0/16","172.16.95.241/32"]
  #       }
  #     }
  #     egress_cidr_rules = {
  #       "egress_1" = {
  #         rules         = [-1, -1, "-1", "targets of alb"]
  #         input_CIDR    = true
  #         cidr_sg_value = ["100.64.0.0/21"]
  #       }
  #     }
  #   },
    
    # "external-alb" = {
    #   description = "sg for public zone_alb"
    #   ingress_cidr_rules = {
    #     "ingress_1" = {
    #       rules         = [80, 80, "tcp", "Internal Users PAT IP"]
    #       input_CIDR    = true
    #       cidr_sg_value = ["203.236.9.162/32", "223.39.97.12/32"]
    #     }
    #     "ingress_2" = {
    #       rules         = [443, 443, "tcp", "Internal Users PAT IP"]
    #       input_CIDR    = true
    #       cidr_sg_value = ["203.236.9.162/32", "223.39.97.12/32"]
    #     }
    #   }
    #   egress_cidr_rules = {
    #     "egress_1" = {
    #       rules         = [-1, -1, "-1", "targets of alb"]
    #       input_CIDR    = true
    #       cidr_sg_value = ["100.64.0.0/21"]
    #     }
    #   }
    # },

     "external-alb" = {
      description = "sg for public zone_alb"
      ingress_cidr_rules = {
        "ingress_1" = {
          rules         = [80, 80, "tcp", "Internal Users PAT IP"]
          input_CIDR    = true
          cidr_sg_value = ["0.0.0.0/0"]
        }
        # "ingress_2" = {
        #   rules         = [443, 443, "tcp", "Internal Users PAT IP"]
        #   input_CIDR    = true
        #   cidr_sg_value = ["203.236.9.162/32", "223.39.97.12/32"]
        # }
      }
      egress_cidr_rules = {
        "egress_1" = {
          rules         = [-1, -1, "-1", "targets of alb"]
          input_CIDR    = true
          cidr_sg_value = ["0.0.0.0/0"]
        }
      }
    },
  
  }
  #############################################
  # Value for rules
  #############################################
  #  ['from port', 'to port', 'protocol', 'description'])
  # Protocols (tcp, udp, icmp, all - are allowed keywords) or numbers (from https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml):
  # All = -1, IPV4-ICMP = 1, TCP = 6, UDP = 17, IPV6-ICMP = 58

}