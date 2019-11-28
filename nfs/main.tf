resource "aws_iam_role" "nfs_server_iam_role" {
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
resource "aws_iam_role_policy" "nfs_server_role_policy" {
  role = "${aws_iam_role.nfs_server_iam_role.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}
resource "aws_iam_instance_profile" "nfs_server_instance_profile" {
  role = "${aws_iam_role.nfs_server_iam_role.name}"
}

resource "aws_security_group" "nfs" {
  vpc_id      = "${var.vpc_id}"
  name_prefix = "${var.environment}-gitlab-nfs-"
  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["${var.cidr}"]
  }
 ingress {
    from_port   = 111
    to_port     = 111
    protocol    = "tcp"
    cidr_blocks = ["${var.cidr}"]
  }
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
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
}

data "template_file" "nfs_user_data" {
  template = "${file("${path.module}/nfs_user_data.tpl")}"
  vars = {
    aws_region = "${var.aws_region}"
    volume_id = "${var.volumne_id}"
  }
}

resource "aws_instance" "gitlab_nfs_server" {
    ami                    = "${var.ami}"
    instance_type          = "${var.instance_type}"
    key_name               = "${var.key_name}"
    subnet_id              = "${var.subnet_id}"
    iam_instance_profile   = "${aws_iam_instance_profile.nfs_server_instance_profile.id}"
    vpc_security_group_ids = ["${aws_security_group.nfs.id}"]
    user_data              = "${data.template_file.nfs_user_data.rendered}"
}