output "out_alb_info" {
  value = aws_lb.alb
}

output "out_alb_listener" {
  value = aws_lb_listener.alb_listener
}

output "out_sg_info" {
  value = aws_security_group.sg
}

output "alb_tgp_arn" {
  value = aws_lb_target_group.alb_tg["bend-1"].arn
}