
# Data Module

This module is used to setup the RDS and Redis data layer.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| db_password | Postgress Database password | string | - | yes |
| environment | Name of the environment (e.g. project-dev); will be prefixed to all resources. | string | - | yes |
| project | Project cost center / cost allocation. | string | - | yes |