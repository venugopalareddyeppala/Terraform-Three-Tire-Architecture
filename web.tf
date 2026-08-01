################################
### WEB TIRE CREATION ###
#################################

####################################
### LAUNCH TEMPLATE FOR WEB TIRE ###
####################################

resource "aws_launch_template" "web_launch_template" {
  name_prefix            = "public-launch-template"
  image_id               = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  key_name               = "venu"
  vpc_security_group_ids = [aws_security_group.sg.id]
  user_data              = base64encode(file("install_apache.sh"))

  tag_specifications {
    resource_type = "instance"
    tags = {
      name = "Web-Launch-Template"
    }
  }
}






##############################################
### APPLICATION LOAD BALANCER FOR WEB TIRE ###
##############################################

resource "aws_lb" "web_lb" {
  name               = "public-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg.id]
  subnets            = [aws_subnet.public_subnet1.id, aws_subnet.public_subnet2.id]
  
  tags = {
    name = "WEB-LB"
  }
}

resource "aws_lb_target_group" "web_tg" {
  name     = "web-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.project_vpc.id
}

resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = aws_lb.web_lb.arn
  port              = 80
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}




#################################
### AUTO SCALING FOR WEB TIRE ###
#################################

resource "aws_autoscaling_group" "web_asg" {
  name                = "web_auto_scaling"
  min_size            = 2
  max_size            = 4
  desired_capacity    = 2
  vpc_zone_identifier = [aws_subnet.public_subnet1.id, aws_subnet.public_subnet2.id]
  target_group_arns   = [aws_lb_target_group.web_tg.arn]
  launch_template {
    id      = aws_launch_template.web_launch_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "public_web_instance"
    propagate_at_launch = true
  }

}