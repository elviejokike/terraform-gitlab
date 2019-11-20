provider "aws" {
  region  = "eu-central-1"
  version = "2.14.0"
}


module "basic-setup" {
  source              = "../../"
  environment         = "play"
  aws_region          = "eu-central-1"
  project             = "sourcecontrol"
  db_password         = "znkCFhXvFeMmY8wK"
  key_name            = "<the name of my service key from EC2>"
}