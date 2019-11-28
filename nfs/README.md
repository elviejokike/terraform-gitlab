# Serving NFS on Amazon EC2

This module is used to setup the NFS on the Amazon EC2 instance. Refer to http://cloudway.io/post/goldmine/nfs-on-amazon-ec2/ for further information


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| environment | Name of the environment (e.g. project-dev); will be prefixed to all resources. | string | - | yes |
| project | Project cost center / cost allocation. | string | - | yes |