module "gitlab-db" {
  source = "github.com/philips-software/terraform-aws-rds?ref=1.1.0"

  name                    = "${var.environment}-gitlabdb"
  environment             = "${var.environment}"
  vpc_id                  = "${module.gitlab-vpc.vpc_id}"
  subnet_ids              = "${join(",", "${module.gitlab-vpc.private_subnet_ids}")}"
  engine                  = "postgres"
  engine_version          = "10.6"
  port                    = "${var.db_password_port}"
  username                = "gitlab"
  password                = "${var.db_password}"
  instance_class          = "${var.db_instance_class}"
  vpc_private_dns_zone_id = "${module.gitlab-vpc.private_dns_zone_id}"

  // override defaults
  storage_encrypted       = "true"
  allocated_storage       = "50"
  storage_type            = "gp2"
  backup_retention_period = "7"
  skip_final_snapshot     = "${var.db_force_destroy}"
}
