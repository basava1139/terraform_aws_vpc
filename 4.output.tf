## output odf ami id 
output "instance_dns_addr" {
  value = aws_instance.web.ami
}