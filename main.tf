
resource "aws_security_group" "gitlab_external_elb_sg" {
  name_prefix = "${format("%s-external-elb-", var.environment)}"
  vpc_id      = "${module.gitlab-vpc.vpc_id}"
  description = "Allows external ELB traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags {
    Name        = "${format("%s external elb", var.environment)}"
    Environment = "${var.environment}"
    Project     = "${var.project}"
  }
}

resource "aws_elb" "gitlab_application" {
  name               = "${var.environment}-gitlab-application"
  subnets         = ["${module.gitlab-vpc.public_subnets}"]
  security_groups = ["${aws_security_group.gitlab_external_elb_sg.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 5
    timeout             = 3
    target              = "HTTP:80/-/readiness"
    interval            = 30
  }
}