resource "local_file" "tg_arn" {
  filename = format("%s/%s", "../asg", "var.tf")
  file_permission   = "0755"
  content = <<EOF
variable target_group_arn { default = "${aws_lb_target_group.citizen_tg.arn}" }
EOF
}
resource "local_file" "hosts" {
  filename = format("%s/%s", "../", "hosts.sh")
  file_permission   = "0600"
  content = <<EOF
#!/bin/bash
lb_dns="${aws_lb.tf_lb_webserver.dns_name}"
db_host="${aws_db_instance.GeoCitDB.endpoint}"  
EOF
}
