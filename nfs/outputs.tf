output "instance_id" {
  value = "${aws_instance.gitlab_nfs_server.id}"
  description = "Instance ID of NFS server"
}
output "instance_ip" {
  value = "${aws_instance.gitlab_nfs_server.private_ip}"
  description = "NFS Server IP"
}
