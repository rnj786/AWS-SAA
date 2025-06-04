variable "region" {
  description = "AWS region"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "db_identifier" {
  description = "RDS DB identifier"
  type        = string
  default     = "my-postgres-db"
}

variable "db_engine_version" {
  description = "Postgres engine version"
  type        = string
  default     = "17.5"
}

variable "db_instance_class" {
  description = "Instance class for RDS"
  type        = string
  default     = "db.t3.micro"
}

variable "db_username" {
  description = "Master username for RDS"
  type        = string
  default     = "postgres"
}

variable "kms_key_name" {
  description = "Name for the KMS key"
  type        = string
  default     = "rds-key"
}

variable "backup_retention_days" {
  description = "Number of days to retain automated backups"
  type        = number
  default     = 7
}