output "out_alb_info" {
  value = aws_lb.alb
}

output "out_alb_listener" {
  value = aws_lb_listener.alb_listener
}

output "out_sg_info" {
  value = aws_security_group.sg
}