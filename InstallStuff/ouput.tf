output "public_ip" {
  value       = aws_instance.test-server
  description = "The public IP of the web serverddddd"
}

output "dup-public_ip" {
  value       = aws_instance.test-server.public_ip
  description = "The public IP of the web serverddddd"
}
