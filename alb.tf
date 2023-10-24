resource "aws_lb" "alb" {
  name               = "Eschool-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_cg.id]

  enable_deletion_protection = false

  enable_cross_zone_load_balancing = true

  subnets = [
    aws_subnet.subnet_public[0].id,
    aws_subnet.subnet_public[1].id
  ]

  tags = {
    Name = "Eschool-alb"
  }
}

resource "aws_lb_listener" "frontend_listener_http" {
  load_balancer_arn = aws_lb.alb.id
  port              = "80"
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.frontend_tg.id
    type             = "forward"
  }
}

resource "aws_lb_listener" "backend_listener_http" {
  load_balancer_arn = aws_lb.alb.id
  port              = "8080"
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.backend_tg.id
    type             = "forward"
  }
}

# resource "aws_lb_listener" "lb_listner_https_test" {
#   load_balancer_arn = aws_lb.sample_lb["test"].id
#   port              = "443"
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = "arn:aws:acm:us-west-2:989898989898:certificate/8a2a7d38-XXXX-4998-aaaa-XXXXX3d7ba"
#   default_action {
#      type             = "forward"
#      target_group_arn = aws_lb_target_group.sample_tg["test"].id
#   }
# }


resource "aws_lb_target_group" "frontend_tg" {
  name        = "Frontend-tg"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.project_vpc.id
  health_check {
    healthy_threshold   = var.health_check["healthy_threshold"]
    interval            = var.health_check["interval"]
    unhealthy_threshold = var.health_check["unhealthy_threshold"]
    timeout             = var.health_check["timeout"]
    path                = var.health_check["path"]
    port                = var.health_check["port"]
  }
}

resource "aws_lb_target_group_attachment" "tg_attachment_frontend" {
  target_group_arn = aws_lb_target_group.frontend_tg.arn
  target_id        = aws_instance.Frontend.id
  port             = 80
}

resource "aws_lb_target_group" "backend_tg" {
  name        = "Backend-tg"
  target_type = "instance"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = aws_vpc.project_vpc.id
  health_check {
    healthy_threshold   = var.health_check["healthy_threshold"]
    interval            = var.health_check["interval"]
    unhealthy_threshold = var.health_check["unhealthy_threshold"]
    timeout             = var.health_check["timeout"]
    path                = var.health_check["path"]
    port                = var.health_check["port"]
  }
}

resource "aws_lb_target_group_attachment" "tg_attachment_backend" {
  target_group_arn = aws_lb_target_group.backend_tg.arn
  target_id        = aws_instance.Backend.id
  port             = 8080
}

resource "aws_route53_record" "eschool" {
  zone_id = data.aws_route53_zone.eschool.zone_id
  name    = "www.eschool-if.net" # Your subdomain or domain
  type    = "CNAME"
  ttl     = "300"
  records = [aws_lb.alb.dns_name]
}
