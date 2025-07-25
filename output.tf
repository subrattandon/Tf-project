#Output for Terminal
output "aws_instance_public_ips" {
    value = aws_instance.myserver.public_ip
    description = "to get public ip of instance"
}
output "instance_urls" {
    description = "URL for nginx server"
    value = "http://${aws_instance.myserver.public_ip}"
  
}
