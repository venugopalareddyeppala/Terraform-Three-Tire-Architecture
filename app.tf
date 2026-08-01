################################
### APP TIRE CREATION ###
#################################

####################################
### LAUNCH TEMPLATE FOR APP TIRE ###
####################################

resource "aws_launch_template" "app_launch_template" {
  name_prefix            = "private_launch_template"
  image_id               = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  key_name               = "venu"
  vpc_security_group_ids = [aws_security_group.sg.id]
  user_data              = base64encode(file("install_apache.sh"))

  tag_specifications {
    resource_type = "instance"

    tags = {
      name = "APP-LAUNCH-TEMPLATE"
    }
  }

}







##############################################
### APPLICATION LOAD BALANCER FOR APP TIRE ###
##############################################

resource "aws_lb" "app_lb" {
  name               = "private-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg.id]
  subnets            = [aws_subnet.private_subnet3.id, aws_subnet.private_subnet4.id]

  tags = {
    name = "APP-LB"
  }
}

resource "aws_lb_target_group" "app_tg" {
  name     = "app-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.project_vpc.id
}

resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}






#################################
### AUTO SCALING FOR APP TIRE ###
#################################

resource "aws_autoscaling_group" "app_asg" {
  name                = "app_auto_scaling"
  min_size            = 2
  max_size            = 4
  desired_capacity    = 2
  vpc_zone_identifier = [aws_subnet.private_subnet3.id, aws_subnet.private_subnet4.id]
  target_group_arns   = [aws_lb_target_group.app_tg.arn]
  launch_template {
    id      = aws_launch_template.app_launch_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "private_app_instance"
    propagate_at_launch = true
  }

}