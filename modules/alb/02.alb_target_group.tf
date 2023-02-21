
#### Target group - Instance, IP

resource "aws_lb_target_group" "alb_tg" {

  for_each = {
    for key, value in var.forward_rules:
      key => value
  }
  name        = "tg-${var.tags.servicetitle}-${var.tags.env}-${each.value.port}-alb-${each.key}"
  port        = each.value.port
  protocol    = each.value.protocol
  target_type = each.value.target_type
  
  load_balancing_algorithm_type = each.value.load_balancing_algorithm_type

  health_check {
    enabled  = true
    protocol = each.value.health_check_1[0]
    port     = each.value.health_check_1[1]
    path = (each.value.health_check_1[0] == "HTTP" ? each.value.health_check_1[2] :
           (each.value.health_check_1[0] == "HTTPS" ? each.value.health_check_1[2] : null))
    timeout = each.value.health_check_2[0]
    interval = each.value.health_check_2[1]
    healthy_threshold = each.value.health_check_2[2]
    unhealthy_threshold = each.value.health_check_2[3]
  }
  
  stickiness {
     enabled         = each.value.stickiness[0]
     cookie_duration = each.value.stickiness[1]
     type            = each.value.stickiness[2]
     cookie_name     = each.value.stickiness[3]
  }
  lifecycle {
    create_before_destroy = false
  }

  vpc_id = var.vpc_id
  
  tags  = merge(var.tags, {
    Name      = "tg-${var.tags.servicetitle}-${var.tags.env}-${var.tags.aws_region_code}-alb-${each.key}" 
  })

}


#### Target Group Attachments : Instance
resource "aws_lb_target_group_attachment" "alb_tg_attach_instance" {

  for_each = {
    for key, value in var.alb_target_list :
    value.target_key => value
    if((length(value.target_id) != 0) && (value.target_type == "instance"))
  }

  target_group_arn = aws_lb_target_group.alb_tg[each.value.target_group_key].arn
  target_id        = each.value.target_id
  #target_id        = var.ec2_info[each.value.target_id].id

  depends_on = [aws_lb_target_group.alb_tg]
}

#### Target Group Attachments : IP
resource "aws_lb_target_group_attachment" "alb_tg_attach_ip" {

  for_each = {
    for key, value in var.alb_target_list :
    value.target_key => value
    if((length(value.target_id) != 0) && (value.target_type == "ip"))
  }

  target_group_arn = aws_lb_target_group.alb_tg[each.value.target_group_key].arn
  target_id        = each.value.target_id
  availability_zone = each.value.target_in_vpc == true ? null : "all"    # IP가 VPC 외부에 있을 때

  depends_on = [aws_lb_target_group.alb_tg]
}