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

################################################################################
# AWS Settings
################################################################################
variable "aws_region" {
  type        = "string"
  description = "The Amazon region"
}

variable "key_name" {
  type        = "string"
  description = "Name of the key pair used for accessing EC2 instances"
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
