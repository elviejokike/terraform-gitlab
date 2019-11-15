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

################################################################################
# EC2 settings
################################################################################
variable "ec2_ami" {
  type        = "string"
  default     = "ami-044fd7c8c74c75eb6"
  description = "GITLAB AMI"
}

variable "ec2_type" {
  type        = "string"
  default     =  "c4.xlarge"
  description = "EC2 Instance Type"
}


################################################################################
# General settings
################################################################################
variable "tags" {
  type        = "map"
  description = "A map of tags to add to the resources"
  default     = {}
}