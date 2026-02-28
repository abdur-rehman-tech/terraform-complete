output "ec2_public_ips" {
  value = {
    for key,instance in aws_instance.my_instance :  key=>instance.public_ip
  }
}