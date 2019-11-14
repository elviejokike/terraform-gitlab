# Terraform module for creating an GITLAB HA module.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| environment | Name of the environment (e.g. project-dev); will be prefixed to all resources. | string | - | yes |
| project | Project cost center / cost allocation. | string | - | yes |