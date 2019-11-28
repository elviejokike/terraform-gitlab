################################################################################
# Generic Project Settings
################################################################################
variable "environment" {
  type        = "string"
  description = "Name of the environment e.g. dev/test/staging/production"
}

variable "project" {
  type        = "string"
  description = "Name of the project"
}

variable "tags" {
  default     = {}
  description = "Map with extra tags to be applied to all ebs volumes"
  type        = "map"
}

################################################################################
# AWS Settings
################################################################################
variable "aws_region" {
  type        = "string"
  description = "The Amazon region"
}

################################################################################
# Network Settings
################################################################################

variable "vpc_id" {
  type        = "string"
  description = "VPC ID"
}

variable "vpc_cidr" {
  type        = "string"
  description = "CIDR"
}

variable "public_subnet_ids" {
  type        = "list"
  description = "The list of public subnet ids"
}

variable "private_subnet_ids" {
  type        = "list"
  description = "The list of private subnet ids"
}

variable "private_hosted_zone_id" {
  type        = "string"
  description = "The private hosted zone id"
}

variable "availability_zones" {
  type        = "list"
  description = "Availability zones"
}



################################################################################
# RDS settings
################################################################################
variable "db_user" {
  type        = "string"
  description = "The user of the database"
  default     = "gitlab"
}

variable "db_password" {
  type        = "string"
  description = "The password of the database"
}

variable "db_password_port" {
  type        = "string"
  default     = "5432"
  description = "The port of the database"
}

variable "db_instance_class" {
  type        = "string"
  default     = "db.t2.medium"
  description = "The instance class of the database"
}

variable "db_force_destroy" {
  default = "false"
}

