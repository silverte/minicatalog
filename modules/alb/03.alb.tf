#####################################################################
##  Resource List                         | Define Name
##  ---------------------------------------------------------------
##  aws_lb                                | internal_alb
##  aws_lb_listener                       | internal_alb_listener
#####################################################################
##  Input Variables
##  ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
##  Variable for Creation           | Meaning                     | Type                | from
##  ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
##  var.application_loadbalancer    | nlb information             | Map                 | ../../main/23.var_alb.tf (config)
##  var.snets_info["key"].id        | ID of subnets               | String              | ../../module/network
##  var.alb_listener                | list of all listeners       | List of object      | ../../main/23.var_alb.tf (config) ../../main/25.module_alb.tf (flattened)
##  var.redirect_rules["key"]       | redirect rules              | Map                 | ../../main/23.var_alb.tf
##  var.fixed_response_rules["key"] | fixed-response rules        | Map                 | ../../main/23.var_alb.tf
##  var.tags                        | common tags                 | Map                 | ../../main/25.module_alb.tf
#####################################################################
##  Output Variables
##  ------------------------------------------------------------------------------------------------------------------------
##  Variable for Output      | Meaning                                       | Type
##  ------------------------------------------------------------------------------------------------------------------------
##
##  ------------------------------------------------------------------------------------------------------------------------

##################################################################
# Resource Definition
##################################################################

################################################################################
# Application Loadbalancer
################################################################################

resource "aws_lb" "alb" {

  for_each = {
    for key, value in var.application_loadbalancer :
    key => value
  }

  name               = "alb-${var.tags.servicetitle}-${var.tags.env}-${each.key}"
  internal           = each.value.internal
  load_balancer_type = "application"
  security_groups    = [for sg in each.value.security_group : aws_security_group.sg[sg].id]
  subnets            = [for subnet in each.value.snets : var.snets_info[subnet].id]

  enable_deletion_protection       = each.value.enable_deletion_protection

  idle_timeout = lookup(each.value, "idle_timeout", 60)
  drop_invalid_header_fields = lookup(each.value, "drop_invalid_header_fields", false)
  enable_http2 = lookup(each.value, "enable_http2", true)
  enable_waf_fail_open = lookup(each.value, "enable_waf_fail_open", false)
  desync_mitigation_mode = lookup(each.value, "desync_mitigation_mode", "defensive")
  
  tags  = merge(var.tags, {
    Name      = "alb-${var.tags.servicetitle}-${var.tags.env}-${var.tags.aws_region_code}-${each.key}"
  })

  depends_on = [var.snets_info, aws_security_group.sg]
}

resource "aws_lb_listener" "alb_listener" {

  for_each = {
    for listener in var.alb_listener :
      listener.listener_key => listener
  }

  load_balancer_arn = aws_lb.alb[each.value.lb_key].arn
  port              = each.value.port
  protocol          = each.value.protocol
  ssl_policy        = each.value.ssl_policy
  certificate_arn   = each.value.certificate_arn

  default_action {

    type = each.value.default_action
    target_group_arn = (each.value.default_action == "forward" ? aws_lb_target_group.alb_tg[each.value.default_rule].arn : null)
    
    dynamic "redirect" {
      for_each = {
        for listener in var.alb_listener :
          listener.listener_key => listener
          if( (listener.default_action == "redirect") && (each.key == listener.listener_key) )
      }
      content {
      status_code = var.redirect_rules[redirect.value.default_rule].status_code
      port = var.redirect_rules[redirect.value.default_rule].port
      protocol = var.redirect_rules[redirect.value.default_rule].protocol
      host = lookup(var.redirect_rules[redirect.value.default_rule], "host", "#{host}")
      path = lookup(var.redirect_rules[redirect.value.default_rule], "path", "/#{path}")
      query = lookup(var.redirect_rules[redirect.value.default_rule], "query", "#{query}")
      }
    }
    
    dynamic "fixed_response" {
      for_each = {
        for listener in var.alb_listener :
          listener.listener_key => listener
          if( (listener.default_action == "fixed-response") && (each.key == listener.listener_key) )
      }
      content {
      content_type = var.fixed_response_rules[fixed_response.value.default_rule].content_type
      message_body = var.fixed_response_rules[fixed_response.value.default_rule].message_body
      status_code = var.fixed_response_rules[fixed_response.value.default_rule].status_code
      }
    }
  
  }
  depends_on = [aws_lb.alb, aws_lb_target_group.alb_tg]
}
