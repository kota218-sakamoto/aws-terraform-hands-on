output "ec2_public_ip" {
  description = "Public IPv4 address of the web EC2"
  value       = aws_instance.web.public_ip
}

output "web_url" {
  description = "URL of the web server"
  value       = "http://${aws_instance.web.public_ip}"
}

output "rds_endpoint" {
  description = "RDS PostgreSQL endpoint"
  value       = aws_db_instance.postgres.address
}

output "rds_port" {
  description = "RDS PostgreSQL port"
  value       = aws_db_instance.postgres.port
}
