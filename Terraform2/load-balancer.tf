# Application Load Balancer
resource "aws_lb" "strapi_alb" {
  name               = "strapi-alb"
  load_balancer_type = "application"
  subnets            = [aws_subnet.subnet-1.id, aws_subnet.subnet-2.id]
  security_groups    = [aws_security_group.alb_sg.id]
}

# BLUE Target Group
resource "aws_lb_target_group" "strapi_tg_blue" {
  name        = "strapi-tg-blue"
  port        = 1337
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"
  health_check {
    path                = "/"
    interval            = 10
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-399"
  }
}

# GREEN Target Group
resource "aws_lb_target_group" "strapi_tg_green" {
  name        = "strapi-tg-green"
  port        = 1337
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"
  health_check {
    path                = "/"
    interval            = 10
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-399"
  }
}

# Listener (ALB Listener with initial target group — CodeDeploy will manage switching)
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.strapi_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.strapi_tg_blue.arn
  }
}
