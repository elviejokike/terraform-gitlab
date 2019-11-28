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

variable "extra_tags" {
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
variable "key_name" {
  type        = "string"
  description = "Name of the key pair used for accessing EC2 instances"
}

################################################################################
# Network Settings
################################################################################

variable "vpc_id" {
  type        = "string"
  description = "VPC ID"
}

variable "cidr" {
  type        = "string"
  description = "CIDR"
}


variable "subnet_id" {
  type        = "string"
  description = "NFS Subnet ID"
}

variable "availability_zone" {
  type        = "string"
  description = "Availability Zone"
}

################################################################################
# EC2 Settings
################################################################################


variable "instance_type" {
  default      = "t2.micro"
}

variable "ami" {
  default      = ""
}


################################################################################
# EBS Settings
################################################################################


variable "volumne_id" {
  type        = "string"
  description = "ID of the volumne to be used as storage."
}

