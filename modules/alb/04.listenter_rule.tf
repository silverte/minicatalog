#####################################################################
##  Resource List                         | Define Name
##  ---------------------------------------------------------------
##  aws_lb_listener_rule                  | internal_alb_listener
#####################################################################
##  Input Variables
##  ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
##  Variable for Creation           | Meaning                           | Type      | from
##  ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
##  var.alb_rule                    | flattened list of rules           | Map       | ../../main/23.var_alb.tf (config)  ../../main/25.module_alb.tf (flattened)
##  var.redirect_rules["key"]       | redirect rules                    | Map       | ../../main/23.var_alb.tf
##  var.fixed_response_rules["key"] | fixed-response rules              | Map       | ../../main/23.var_alb.tf
##  var.alb_rule_condition          | flattened list of rule conditions | Map       | ../../main/23.var_alb.tf (config)  ../../main/25.module_alb.tf (flattened)
##  var.rule_conditions             | Information of rule conditions    | Map       | ../../main/23.var_alb.tf
##  var.tags                        | common tags                       | Map       | ../../main/25.module_alb.tf
#####################################################################

##################################################################
# Resource Definition
##################################################################

################################################################################
# Listener rules of Application Loadbalancer
################################################################################

resource "aws_lb_listener_rule" "alb_listener_rule" {

  for_each = {
    for rules in var.alb_rule : rules.rule_key => rules
  }

  listener_arn = aws_lb_listener.alb_listener[each.value.listener_key].arn
  priority     = each.value.priority


action {

  type = each.value.action
  target_group_arn = (each.value.action == "forward" ? aws_lb_target_group.alb_tg[each.value.rule].arn : null)
  
  dynamic "redirect" {
    for_each = {
      for rules in var.alb_rule : rules.rule_key => rules
      if(rules.action == "redirect" && (each.key == rules.rule_key) )
  }
    content {
    status_code = var.redirect_rules[redirect.value.rule].status_code
    port = var.redirect_rules[redirect.value.rule].port
    protocol = var.redirect_rules[redirect.value.rule].protocol
    host = lookup(var.redirect_rules[redirect.value.rule], "host", "#{host}")
    path = lookup(var.redirect_rules[redirect.value.rule], "path", "/#{path}")
    query = lookup(var.redirect_rules[redirect.value.rule], "query", "#{query}")
    }
  }
  
  dynamic "fixed_response" {
    for_each = {
      for rules in var.alb_rule : rules.rule_key => rules
      if(rules.action == "fixed-response" && (each.key == rules.rule_key) )
  }
    content {
    content_type = var.fixed_response_rules[fixed_response.value.rule].content_type
    message_body = var.fixed_response_rules[fixed_response.value.rule].message_body
    status_code = var.fixed_response_rules[fixed_response.value.rule].status_code
    }
  }
}

  dynamic "condition" {
    for_each = {
      for value in var.alb_rule_condition :
      "${each.value.rule_key}.${value.condition_key}" => value
      if((value.rule_key == each.value.rule_key) && (var.rule_conditions[value.condition_key].field == "host-header"))
    }
    content {
      host_header {
        values = [var.rule_conditions[condition.value.condition_key].values]
      }
    }
  }
  
    dynamic "condition" {
    for_each = {
      for value in var.alb_rule_condition :
      "${each.value.rule_key}.${value.condition_key}" => value
      if((value.rule_key == each.value.rule_key) && (var.rule_conditions[value.condition_key].field == "path-pattern"))
    }
    content {
      path_pattern {
        values = [var.rule_conditions[condition.value.condition_key].values]
      }
    }
  }

  depends_on = [aws_lb.alb, aws_lb_target_group.alb_tg, aws_lb_listener.alb_listener ]
}


