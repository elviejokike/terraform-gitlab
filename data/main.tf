module "gitlab-db" {
  source                  = "github.com/philips-software/terraform-aws-rds?ref=1.1.0"
  name                    = "gitlab"
  environment             = "${var.environment}"
  vpc_id                  = "${var.vpc_id}"
  subnet_ids              = "${join(",", "${var.private_subnet_ids}")}"
  engine                  = "postgres"
  engine_version          = "10.6"
  port                    = "${var.db_password_port}"
  username                = "${var.db_user}"
  password                = "${var.db_password}"
  instance_class          = "${var.db_instance_class}"
  vpc_private_dns_zone_id = "${var.private_hosted_zone_id}"

  // override defaults
  storage_encrypted       = "true"
  allocated_storage       = "50"
  storage_type            = "gp2"
  backup_retention_period = "7"
  skip_final_snapshot     = "${var.db_force_destroy}"
}


// REDIS

resource "aws_elasticache_subnet_group" "gitlab_redis_subnet_group" {
  name       = "${var.environment}-gitlab-redis"
  subnet_ids = ["${var.private_subnet_ids}"]
}

resource "aws_elasticache_replication_group" "gitlab_redis" {
  replication_group_id          = "${var.environment}-gitlab-redis"
  replication_group_description = "Redis cluster powering GitLab"
  engine                        = "redis"
  engine_version                = "3.2.10"
  node_type                     = "cache.m4.large"
  number_cache_clusters         = 3
  port                          = 6379
  availability_zones            = ["${var.availability_zones}"]
  automatic_failover_enabled    = true
  security_group_ids            = ["${aws_security_group.gitlab_redis_sg.id}"]
  subnet_group_name             = "${aws_elasticache_subnet_group.gitlab_redis_subnet_group.name}"
}

resource "aws_security_group" "gitlab_redis_sg" {
  name_prefix = "${format("%s-gitlab-redis-sg", var.environment)}"
  vpc_id      = "${var.vpc_id}"
  description = "Allows Redis traffic"

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = [
      "${var.vpc_cidr}",
    ]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags {
    Environment = "${var.environment}"
    Project     = "${var.project}"
  }
}