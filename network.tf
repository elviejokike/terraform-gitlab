
module "gitlab-vpc" {
  source = "github.com/philips-software/terraform-aws-vpc.git?ref=1.3.0"

  environment = "${var.environment}"
  aws_region  = "${var.aws_region}"

  project                    = "${var.project}"
  create_private_hosted_zone = "true"
  create_private_subnets     = "true"
}

data "template_file" "bastion_init" {
  template = "${file("${path.module}/templates/bastion-init.sh")}"
}

data "template_cloudinit_config" "bastion_config" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/x-shellscript"
    content      = "${data.template_file.bastion_init.rendered}"
  }
}

module "gitlab-bastion" {
  source = "github.com/philips-software/terraform-aws-bastion?ref=1.0.0"
  enable_bastion = "true"

  environment = "${var.environment}"
  project     = "${var.project}"

  aws_region = "${var.aws_region}"
  key_name   = "${var.key_name}"
  subnet_id  = "${element(module.gitlab-vpc.public_subnets, 0)}"
  vpc_id     = "${module.gitlab-vpc.vpc_id}"

  user_data = "${data.template_cloudinit_config.bastion_config.rendered}"
}
