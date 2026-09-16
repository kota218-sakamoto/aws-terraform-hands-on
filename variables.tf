variable "ssh_allowed_cidr" {
  description = "CIDR allowed to SSH to EC2"
  type        = string
}

variable "ec2_key_name" {
  description = "EC2 key pair name"
  type        = string
}

variable "db_password" {
  description = "Master password for PostgreSQL RDS"
  type        = string
  sensitive   = true
}
