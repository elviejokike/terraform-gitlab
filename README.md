# Terraform module for Installing GitLab HA on Amazon Web Services

Reference: https://docs.gitlab.com/ee/install/aws/

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| db_password | Postgress Database password | string | - | yes |
| environment | Name of the environment (e.g. project-dev); will be prefixed to all resources. | string | - | yes |
| project | Project cost center / cost allocation. | string | - | yes |