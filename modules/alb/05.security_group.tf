resource "aws_security_group" "sg" {
  for_each = var.sg_information
  
  name                  = "sgrp-${each.key}"
  description           = each.value.description
  vpc_id                = var.vpc_id

  tags  = merge(var.tags, {
    Name      = "sgrp-${var.tags.servicetitle}-${var.tags.env}-${var.tags.aws_region_code}-${each.key}"
  })
}


#################### ingress ######################
# Security group rules with "cidr_blocks" and it uses list of rules names
resource "aws_security_group_rule" "ingress_rules_cidr" {
  for_each = {
    for ingress_value in var.ingress_cidr_rules : 
    "${ingress_value.sg_key}.${ingress_value.ingress_key}" => ingress_value
    if (ingress_value.input_CIDR)
  }
  
  security_group_id = aws_security_group.sg[each.value.sg_key].id
  type              = "ingress"
  description      = each.value.rules[3]
  cidr_blocks = each.value.cidr_sg_value
  from_port = each.value.rules[0]
  to_port   = each.value.rules[1]
  protocol  = each.value.rules[2]
  
}

resource "aws_security_group_rule" "ingress_rules_sg" {
  for_each = {
    for ingress_value in var.ingress_cidr_rules : 
    "${ingress_value.sg_key}.${ingress_value.ingress_key}" => ingress_value
    if !(ingress_value.input_CIDR)
  }
  
  security_group_id = aws_security_group.sg[each.value.sg_key].id
  type              = "ingress"
  description      = each.value.rules[3]
  source_security_group_id = aws_security_group.sg[each.value.cidr_sg_value[0]].id
  from_port = each.value.rules[0]
  to_port   = each.value.rules[1]
  protocol  = each.value.rules[2]
}



#################### egress ######################
# Security group rules with "cidr_blocks" and it uses list of rules names
resource "aws_security_group_rule" "egress_rules_cidr" {
  for_each = {
    for egress_value in var.egress_cidr_rules : 
    "${egress_value.sg_key}.${egress_value.egress_key}" => egress_value
    if (egress_value.input_CIDR)
  }
  
  security_group_id = aws_security_group.sg[each.value.sg_key].id
  type              = "egress"
  description      = each.value.rules[3]
  cidr_blocks = each.value.cidr_sg_value
  from_port = each.value.rules[0]
  to_port   = each.value.rules[1]
  protocol  = each.value.rules[2]  
}

resource "aws_security_group_rule" "egress_rules_sg" {
  for_each = {
    for egress_value in var.egress_cidr_rules : 
    "${egress_value.sg_key}.${egress_value.egress_key}" => egress_value
    if !(egress_value.input_CIDR)
  }
  
  security_group_id = aws_security_group.sg[each.value.sg_key].id
  type              = "egress"
  description      = each.value.rules[3]
  source_security_group_id = aws_security_group.sg[each.value.cidr_sg_value[0]].id
  from_port = each.value.rules[0]
  to_port   = each.value.rules[1]
  protocol  = each.value.rules[2]  
}