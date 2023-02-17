#####################################################################
##  TemplateName:  23.var_alb.tf
##  Purpose:    Define Variables for application loadbalancer resources - Affected Resource (ALB, ALB listener rule)
#####################################################################

#######################################################
## Variables for Application Loadbalancer
#######################################################

################################################################################################################
##  Variables List - Locals
##  ---------------------------------------------------------------
##  Variable Name                                                |  Type           | Meaning 
##  ---------------------------------------------------------------
##  application_loadbalancer                                     | Map             | All ALB
##  application_loadbalancer."key".internal                      | boolean         | true : internal / false : internet-facing   
##  application_loadbalancer."key".snets                         | list            | subnets(key name) of ALB (key name from module.network)
##  application_loadbalancer."key".security_group                | list            | security groups(key name) of ALB (key name from main/var_sg_for_alb.tf)
##  application_loadbalancer."key".enable_deletion_protection    | boolean         | prevent from deleting ALB
##  application_loadbalancer."key".idle_timeout                  | boolean         | the connection is allowed to be idle (Defualt=60)
##  application_loadbalancer."key".drop_invalid_header_fields    | boolean         | Indicates whether HTTP headers with header fields that are not valid are removed by the load balancer (Default=false)
##  application_loadbalancer."key".enable_http2                  | boolean         | Indicates whether HTTP/2 is enabled (Defualt=true)
##  application_loadbalancer."key".enable_waf_fail_open          | boolean         | Indicates whether to allow a WAF-enabled load balancer to route requests to targets 
##                                                                                   if it is unable to forward the request to AWS WAF. (Defualt=false)
##  application_loadbalancer."key".desync_mitigation_mode        | string          | Determines how the load balancer handles requests that might pose a security risk 
##                                                                                   to an application due to HTTP desync. [monitor, defensive (default), strictest]
##  application_loadbalancer."key".listeners                     | list of object  | All listeners
##  ..listeners.port                                             | number          | port number of listener
##  ..listeners.protocol                                         | string          | protocol of listener (HTTP/HTTPS)
##  ..listeners.ssl_policy                                       | string          | ssl policy of listener (only for protocol HTTPS/TLS.. ) (Default : "ELBSecurityPolicy-2016-08")
##  ..listeners.certificate_arn                                  | string          | arn of default SSL certificate. (only for protocol HTTPS/TLS.. arn of ACM)
##  ..listeners.default_action                                   | string          | Type of default action for listener (forward / redirect / fixed-response)
##  ..listeners.default_rule                                     | string          | Rule definition of default action for listener (Key name from variables "*_rules" )
##  ..listeners.additional_rules                                 | List of Object  | Rule definition of adittional action for listener (Key name from variables "*_rules" )
##  ..listeners.additional_rules.priority                        | number          | The priority for the rule between 1 and 50000
##  ..listeners.additional_rules.condition                       | list            | List of conditions(Key name) for the rule (key name from "rule_conditions" )
##  ..listeners.additional_rules.action                          | string          | Type of action for the rule (forward / redirect / fixed-response)
##  ..listeners.additional_rules.rule                            | string          | Rule definition of action for listener (Key name from variables "*_rules" )
##  forward_rules                                                | Map             | Target group of ALB
##  forward_rules."key".protocol                                 | string          | protocol of target group (HTTP / HTTPS / TCP / TCP_UDP / TLS / UDP / GENEVE)
##  forward_rules."key".protocol_version                         | string          | protocol version of target group (only for HTTP/HTTPS)
##  forward_rules."key".port                                     | number          | port number of target group
##  forward_rules."key".target_type                              | string          | target type of target group (ip/instance)
##  forward_rules."key".load_balancing_algorithm_type            | string          | load_balancing_algorithm_type [ round_robin / least_outstanding_requests ]
##  forward_rules."key".stickiness                               | list(4)         | stickiness enable [ enabled, duration, type, cookie_name]
##                                                                                           Example : [ ture/false, 1-604800(sec), lb_cookie/app_cookie, "myCookie_name"(only for app_cookie) ]  
##  forward_rules."key".health_check_1                           | list(3)         | options of health check [ protocol, port, path ]
##  forward_rules."key".health_check_2                           | list(4)         | options of health check [ timeout, interval, healthy_threshold, unhealthy_threshold]
##                                                                                 |                              healthy/unhealthy_threshold must be same.
##  forward_rules."key".target_id                                | list            | target ids (ip or instance id or alb arn)
##  forward_rules."key".target_in_vpc                            | boolean         | Location of targets (Inside of VPC : true / outside of VPC : false)
##  redirect_rules                                               | Map             | Listener rule(redirect) for action of alb
##  redirect_rules."key".status_code                             | string          | The HTTP redirect code (HTTP_301 / HTTP_302)
##  redirect_rules."key".port                                    | string          | The port (1-65535 / #{Port}) / Must be different from listener port / Default : #{Port}
##  redirect_rules."key".protocol                                | string          | (HTTP / HTTPS / #{Protocol})  / Default : #{Protocol}
##  redirect_rules."key".host                                    | string          | The hostname. Default : #{host}
##  redirect_rules."key".path                                    | string          | The absolute path, starting with the leading "/". Default : /#{path}
##  redirect_rules."key".query                                   | string          | The query parameters, URL-encoded when necessary. Default : #{query}
##  fixed_response_rules                                         | Map             | Listener rule(fixed_response) action of alb
##  fixed_response_rules."key".content_type                      | string          | The content type. (text/plain, text/css, text/html, application/javascript, application/json)
##  fixed_response_rules."key".message_body                      | string          | The message body.
##  fixed_response_rules."key".status_code                       | string          | The HTTP response code. (2XX, 4XX, or 5XX)
##  rule_conditions                                              | Map             | Define conditions of listener rules
##  rule_conditions."key".field                                  | string          | (path_pattern / host_header)
##  rule_conditions."key".values                                 | string          | value for condition

##  ALB_Creator                                                  | String          | Employee Number of Creator for ALB Resources
##  ALB_Operator1                                                | String          | Employee Number of main Operator for ALB Resources
##  ALB_Operator2                                                | String          | Employee Number of sub Operator for ALB Resources
################################################################################################################

#########################################
# Edit Variables
#########################################

locals {
    
  ###############
  # application Load Balancer
  ###############
  
  application_loadbalancer = {
  
    # "admin" = {
    #   internal = true
    #   snets = ["private-uniq1-a", "private-uniq2-c"]
    #   security_group = ["internal-alb", ]
      
    #   enable_deletion_protection = false
    #   idle_timeout = 60
    #   drop_invalid_header_fields = false
    #   enable_http2 = true
    #   enable_waf_fail_open = false
    #   desync_mitigation_mode = "defensive"
    
    #   listeners = [ 
    #     {
    #       port = 80
    #       protocol = "HTTP"
    #       ssl_policy = "" 
    #       certificate_arn = ""
    #       default_action = "forward"
    #       default_rule = "bend-1"
    #       additional_rules = [
    #         { 
    #           priority = 200
    #           condition = [ "cond-2", ]
    #           action = "forward"
    #           rule = "bend-2"
    #         },
    #         { 
    #           priority = 300
    #           condition = [ "cond-1", ]
    #           action = "fixed-response"
    #           rule = "fixed-1"
    #         },
    #         { 
    #           priority = 400
    #           condition = [ "cond-1", "cond-2"]    
    #           action = "redirect"
    #           rule = "red-1"
    #         },
    #         { 
    #           priority = 500
    #           condition = [ "cond-1", ]
    #           action = "forward"
    #           rule = "bend-3"
    #         },
    #         { 
    #           priority = 600
    #           condition = [ "cond-1"]    
    #           action = "redirect"
    #           rule = "red-1"
    #         },
    #       ]
    #     },
        
    #     {
    #       port = 8080
    #       protocol = "HTTP"
    #       ssl_policy = ""
    #       certificate_arn = ""
    #       default_action = "redirect"
    #       default_rule = "red-2"
    #       additional_rules = []
    #     },
      
    #   ] ## end of block(application_loadbalancer."key".listener)
    # }  ## end of block(application_loadbalancer."key")
    
    # "portal" = {
    #   internal = false
    #   snets = ["public1-a", "public2-c"]
    #   security_group = ["external-alb", ]
      
    #   enable_deletion_protection = false
    #   idle_timeout = 60
    #   drop_invalid_header_fields = false
    #   enable_http2 = true
    #   enable_waf_fail_open = false
    #   desync_mitigation_mode = "defensive"
    
    #   listeners = [
    #     {
    #       port = 80
    #       protocol = "HTTP"
    #       ssl_policy = ""
    #       certificate_arn = ""
    #       default_action = "fixed-response"
    #       default_rule = "fixed-1"
    #       additional_rules = [
    #         { 
    #           priority = 200
    #           condition = [ "cond-2", ]
    #           action = "redirect"
    #           rule = "red-1"
    #         },
    #       ]
    #     },
      
    #   ] ## end of block(application_loadbalancer."key".listener)
    # }  ## end of block(application_loadbalancer."key")

    "web" = {
      internal = false
      snets = ["public1-a", "public2-c"]
      security_group = ["external-alb", ]
      
      enable_deletion_protection = false
      idle_timeout = 60
      drop_invalid_header_fields = false
      enable_http2 = true
      enable_waf_fail_open = false
      desync_mitigation_mode = "defensive"
    
      listeners = [
        {
          port = 80
          protocol = "HTTP"
          ssl_policy = ""
          certificate_arn = ""
          default_action = "fixed-response"
          default_rule = "fixed-1"
          additional_rules = [
            { 
              priority = 100
              condition = [ "cond-3", ]
              action = "forward"
              rule = "bend-1"
            },
            # { 
            #   priority = 200
            #   condition = [ "cond-3", ]
            #   action = "forward"
            #   rule = "bend-1"
            # },
          ]
        },
      
      ] ## end of block(application_loadbalancer."key".listener)
    }  ## end of block(application_loadbalancer."key")


  }  ## end of block(application_loadbalancer)
  
  ###############
  # Listener Forward rules (forward rule & target group will be made)
  ###############
  
  forward_rules = {
    "bend-1" = {
      protocol   = "HTTP"      
      protocol_version = ""       
      port       = 80
      target_type        = "ip"
      load_balancing_algorithm_type = "round_robin"   
      
      stickiness = [ false, 86400, "lb_cookie", "" ]
      
      health_check_1 = [ "HTTP", "traffic-port", "/test"]
      health_check_2 = [5, 30, 3, 3]
      
      #target_id  = ["100.64.0.19", "100.64.0.21", ]
      target_id  = []
      target_in_vpc = true   
    },
    
    # "bend-2" = {
    #   protocol   = "HTTP"     
    #   protocol_version = ""       
    #   port       = 80
    #   target_type        = "instance"
    #   load_balancing_algorithm_type = "round_robin" 
    
    #   stickiness = [true, 86400,"lb_cookie", ""]
          

    #   health_check_1 = [ "HTTP", 8800, "/"]
    #   health_check_2 = [5, 30, 3, 3]

      
    #   target_id  = ["", ]
    #   target_in_vpc = true  
    # },
    # "bend-3" = {
    #   protocol   = "HTTP"   
    #   protocol_version = "" 
    #   port       = 80
    #   target_type        = "instance"
    #   load_balancing_algorithm_type = "round_robin"
   
    #   stickiness = [true, 86400,"lb_cookie", ""]

    #   health_check_1 = [ "HTTP", 8800, "/"]
    #   health_check_2 = [5, 30, 3, 3]

    #   target_id  = ["", ]
    #   target_in_vpc = true  
    # },
   }
 
  # ###############
  # # Listener redirect rules
  # ###############
  
   redirect_rules = { #보안 체크리스트 암호화 통신(HTTPS) 설정 필요
    # "red-1" = {
    #   status_code = "HTTP_301"
    #   port = "443"
    #   protocol = "HTTPS"
    #   host = "#{host}"
    #   path = "/#{path}"
    #   query = "#{query}"
    # },
    
    # "red-2" = {
    #   status_code = "HTTP_301"
    #   port = "80"
    #   protocol = "HTTP"
    #   host = "#{host}"          
    #   path = "/#{path}"        
    #   query = "#{query}"
    # },
  }
  
  ###############
  # Listener fixed response rules
  ###############
  
  fixed_response_rules = {
    "fixed-1" = {
      content_type = "text/plain"    ## text/plain, text/css, text/html, application/javascript, application/json
      message_body = ""
      status_code = "404"              ## 2XX, 4XX, 5XX
    },
  }
  
  ###############
  # conditions of listener rules
  ###############
  
  rule_conditions = {
    "cond-1" = {
      field = "path-pattern"
      values = "/mctl-planner/*"
    },
    "cond-2" = {
      field = "host-header"
      values = "my-service.*.terraform.io"
    },
     "cond-3" = {
      field = "path-pattern"
      values = "/"
    }
  }

  
  
  ###############
  # application loadbalancer Resources Creator & Operators
  ###############
  alb_Creator             = "07326"           # NW Resources creator
  alb_Operator1           = ""           # NW Resources operator1
  alb_Operator2           = ""           # NW Resources operator2
    
}

