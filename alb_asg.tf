resource "aws_launch_configuration" "task4" {
  name_prefix     = "task4"
  image_id        = "ami-0a824feed96a39165"
  instance_type   = "t2.micro"
  user_data       = file("userdata.sh")
  security_groups = [aws_security_group.task4.id]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "task4" {
  name                 = "task4"
  min_size             = 1
  max_size             = 3
  desired_capacity     = 1
  launch_configuration = aws_launch_configuration.task4.name
  vpc_zone_identifier  = [aws_subnet.task4-public-1.id, aws_subnet.task4-public-2.id]

  health_check_type    = "ELB"

  tag {
    key                 = "Name"
    value               = "task4"
    propagate_at_launch = true
  }
}

resource "aws_lb" "task4" {
  name               = "task4"
  internal           = false
  load_balancer_type = "application"
  security_groups   = [aws_security_group.task4_lb.id]
  subnet_mapping {
    subnet_id = aws_subnet.task4-public-1.id
    allocation_id = null
  }  
  subnet_mapping {
    subnet_id = aws_subnet.task4-public-2.id  
    allocation_id = null
  } 

}

resource "aws_lb_listener" "task4" {
  load_balancer_arn = aws_lb.task4.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.task4.arn
  }
}

resource "aws_lb_target_group" "task4" {
  name     = "asg-task4"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.task4.id
}

resource "aws_lb_target_group_attachment" "task4" {
  target_group_arn = aws_lb_target_group.task4.arn
  target_id        = aws_instance.task_4.id
  port             = 80
}

resource "aws_autoscaling_attachment" "task4" {
  autoscaling_group_name = aws_autoscaling_group.task4.id
  lb_target_group_arn   = aws_lb_target_group.task4.arn
}

resource "aws_security_group" "task4_lb" {
  name = "learn-asg-terramino-lb"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = aws_vpc.task4.id
}