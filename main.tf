
resource "aws_security_group" "gitlab_external_elb_sg" {
  name_prefix = "${format("%s-gitlab-external-elb-", var.environment)}"
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

resource "aws_security_group" "gitlab_instance_sg" {
  name_prefix = "${format("%s-gitlab-instance-sg-", var.environment)}"
  vpc_id      = "${module.gitlab-vpc.vpc_id}"
  description = "Allows traffic between instances"

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

  ingress {
    protocol  = "tcp"
    from_port = 0
    to_port   = 65535

    cidr_blocks = [
      "${module.gitlab-vpc.vpc_cidr}",
    ]
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

resource "aws_alb" "gitlab_alb" {
  name               = "${var.environment}-gitlab-alb"
  subnets         = ["${module.gitlab-vpc.public_subnets}"]
  security_groups = ["${aws_security_group.gitlab_external_elb_sg.id}"]

  enable_deletion_protection = false

  tags = "${merge(map("Name", format("%s", "${var.environment}-gitlab")),
            map("Environment", format("%s", var.environment)),
            map("Project", format("%s", var.project)),
            var.tags)}"
}

resource "aws_alb_listener" "gitlab_alb_http_listener" {

  load_balancer_arn = "${aws_alb.gitlab_alb.arn}"
  protocol          = "HTTP"
  port              = "80"

  default_action {
    target_group_arn = "${aws_alb_target_group.gitlab_alb_http_target_group.arn}"
    type             = "forward"
  }
}

resource "aws_alb_target_group" "gitlab_alb_http_target_group" {
  protocol          = "HTTP"
  port              = "80"
  vpc_id   =        "${module.gitlab-vpc.vpc_id}"

  lifecycle {
    create_before_destroy = true
  }

  tags = "${merge(map("Name", format("%s", "${var.environment}-gitlab")),
            map("Environment", format("%s", var.environment)),
            map("Project", format("%s", var.project)),
            var.tags)}"
}


data "template_file" "gitlab_instance_role_trust_policy" {
  template = "${file("${path.module}/policies/instance-role-trust-policy.json")}"
}

resource "aws_iam_role" "gitlab_iam_instance_role" {
  name               = "${var.environment}-gitlab-iam-instance-role"
  assume_role_policy = "${data.template_file.gitlab_instance_role_trust_policy.rendered}"
}

resource "aws_iam_instance_profile" "gitlab_instance_profile" {
  name = "${var.environment}-gitlab-instance-profile"
  role = "${aws_iam_role.gitlab_iam_instance_role.name}"
}


data "template_file" "gitlab_application_user_data" {
  template = "${file("${path.module}/templates/application_user_data.tpl")}"
  vars {
    postgres_database     = "gitlab"
    postgres_username     = "${var.db_user}"
    postgres_password     = "${var.db_password}"
    postgres_endpoint     = "${replace("${module.gitlab-db.endpoint}",":5432","")}"
  }
}

resource "aws_launch_configuration" "gitlab_launch_configuration" {
  name_prefix     = "${var.environment}-gitlab-launch-configuration"

  image_id        = "${var.ec2_ami}"
  instance_type   = "${var.ec2_type}"
  key_name        = "${var.key_name}"
  security_groups = ["${aws_security_group.gitlab_instance_sg.id}"]

  associate_public_ip_address = false
  iam_instance_profile = "${aws_iam_instance_profile.gitlab_instance_profile.name}"

  lifecycle {
    create_before_destroy = true
  }

  user_data       = "${data.template_file.gitlab_application_user_data.rendered}"
}

resource "aws_autoscaling_group" "gitlab_autoscaling_group" {
  
  launch_configuration = "${aws_launch_configuration.gitlab_launch_configuration.name}"
  min_size             = 1
  max_size             = 2
  vpc_zone_identifier  = ["${module.gitlab-vpc.private_subnets}"]
  health_check_type    = "EC2"
  force_delete         = true

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_attachment" "gitlab_asg_attachment_bar" {
  autoscaling_group_name = "${aws_autoscaling_group.gitlab_autoscaling_group.id}"
  alb_target_group_arn   = "${aws_alb_target_group.gitlab_alb_http_target_group.arn}"
}