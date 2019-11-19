#cloud-config

write_files:
  - content: |
      # Disabe built-in postgres and redis
      postgresql['enable'] = false
      redis['enable'] = false
      # External postgres settings
      gitlab_rails['db_adapter'] = "postgresql"
      gitlab_rails['db_encoding'] = "unicode"
      gitlab_rails['db_database'] = "${postgres_database}"
      gitlab_rails['db_username'] = "${postgres_username}"
      gitlab_rails['db_password'] = "${postgres_password}"
      gitlab_rails['db_host'] = "${postgres_endpoint}"
      gitlab_rails['db_port'] = 5432
      gitlab_rails['auto_migrate'] = true
      gitlab_rails['redis_host'] = "${redis_endpoint}"
      gitlab_rails['redis_port'] = 6379
    path: /etc/gitlab/gitlab.rb
    permissions: '0600'

runcmd:
  - [ gitlab-ctl, reconfigure ]