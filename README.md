# Terraform module for Installing GitLab HA on Amazon Web Services

Reference: https://docs.gitlab.com/ee/install/aws/

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| db_password | Postgress Database password | string | - | yes |
| ec2_ami | Gitlab AMI  | string | ami-044fd7c8c74c75eb6 | yes |
| ec2_type | EC2 type used for running gitlab applciation  | string | c4.xlarge | yes |
| environment | Name of the environment (e.g. project-dev); will be prefixed to all resources. | string | - | yes |
| project | Project cost center / cost allocation. | string | - | yes |