output "vpc_id" {
  value = "${element(concat(list(module.gitlab-vpc.vpc_id), list("")), 0)}"

  //  value       = "${module.gitlab-vpc.vpc_id}"
  description = "Associated VPC id that has been created"
}

output "vpc_cidr" {
  value       = "${module.gitlab-vpc.vpc_cidr}"
  description = "Associated VPC cidr block"
}

output "public_subnet_ids" {
  value       = "${module.gitlab-vpc.public_subnets}"
  description = "The list of public subnet ids"
}

output "private_subnet_ids" {
  value       = "${module.gitlab-vpc.private_subnets}"
  description = "The list of private subnet ids"
}

output "private_hosted_zone_id" {
  value       = "${module.gitlab-vpc.private_dns_zone_id}"
  description = "The private hosted zone id"
}

output "availability_zones" {
  value       = "${module.gitlab-vpc.availability_zones}"
  description = "The vpc availability zones"
}

output "bastion_public_ip" {
  description = "Public ip of the created instance."
  value       = "${module.gitlab-bastion.public_ip}"
}