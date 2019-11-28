output "db_endpoint" {
  value = "${module.gitlab-db.endpoint}"
  description = "RDS Endpoint"
}

output "redis_endpoint" {
  value = "${aws_elasticache_replication_group.gitlab_redis.primary_endpoint_address}"
  description = "Redis Endpoint"
}