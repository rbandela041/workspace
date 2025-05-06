resource "aws_lb" "alb" {
  name               = "${local.vpc_name}-alb"
  internal           = false #this will create an external load balancer to access the application from outside
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_all_sg.id]
  subnets            = aws_subnet.public-subnets[*].id ##Star means all the subnets will be attaached to the load balancer
  enable_deletion_protection = false
  enable_http2       = true
  enable_cross_zone_load_balancing = true

  tags = {
    Name = "${local.vpc_name}-alb"
    Env  = local.env
  }
}

##Create listener for the load balancer
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"  ##the default action is to forward the traffic to the target group
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }
}

##Create target group for the load balancer
resource "aws_lb_target_group" "alb_target_group" {
  name     = "${local.vpc_name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc1.id

}

##Create target group attachment for the load balancer
resource "aws_lb_target_group_attachment" "alb_target_group_attachment" {
  count               = length(aws_instance.web_server.*.id) ##this will create the target group attachment for all the instances created in the web server module
  target_group_arn    = aws_lb_target_group.alb_target_group.arn
  target_id           = element(aws_instance.web_server.*.id, count.index) ##this will attach the instances to the target group
  port                = 80
}