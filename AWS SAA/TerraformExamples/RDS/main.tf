# RDS PostgreSQL Terraform Script

provider "aws" {
  region = var.region
}

# KMS Key for RDS Encryption
resource "aws_kms_key" "rds_kms" {
  description             = "KMS key for RDS encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = "*"
        },
        Action = "kms:*",
        Resource = "*"
      }
    ]
  })
  tags = {
    Name = var.kms_key_name
  }
}

# Store DB credentials in Secrets Manager
resource "random_password" "db_password" {
  length  = 16
  special = true
}

resource "aws_secretsmanager_secret" "db_secret" {
  name = "${var.db_identifier}-creds"
}

resource "aws_secretsmanager_secret_version" "db_secret_version" {
  secret_id     = aws_secretsmanager_secret.db_secret.id
  secret_string = jsonencode({
    username = var.db_username
    password = random_password.db_password.result
  })
}

# Security Group for RDS
resource "aws_security_group" "rds_sg" {
  name        = "${var.db_identifier}-rds-sg"
  description = "Allow DB access"
  vpc_id      = var.vpc_id

  # Example: Allow only from private subnets (customize as needed)
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Primary RDS Instance (Multi-AZ enabled, but only one instance deployed)
resource "aws_db_instance" "postgres" {
  identifier              = var.db_identifier
  engine                  = "postgres"
  engine_version          = var.db_engine_version
  instance_class          = var.db_instance_class
  allocated_storage       = 20
  storage_type            = "gp3"
  username                = var.db_username
  password                = random_password.db_password.result
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  multi_az                = true
  storage_encrypted       = true
  kms_key_id              = aws_kms_key.rds_kms.arn
  backup_retention_period = var.backup_retention_days
  deletion_protection     = false
  skip_final_snapshot     = true

  # Place in private subnets
  publicly_accessible     = false

  # Enable automatic minor version upgrades
  auto_minor_version_upgrade = true

  tags = {
    Name = var.db_identifier
  }
}

# DB Subnet Group (using private subnets from VPC module)
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "${var.db_identifier}-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "${var.db_identifier}-subnet-group"
  }
}

# Read Replica in another AZ (pick the second private subnet)
resource "aws_db_instance" "postgres_replica" {
  identifier               = "${var.db_identifier}-replica"
  engine                   = "postgres"
  instance_class           = var.db_instance_class
  replicate_source_db      = aws_db_instance.postgres.arn
  db_subnet_group_name     = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids   = [aws_security_group.rds_sg.id]
  storage_type             = "gp3"
  allocated_storage        = 20
  kms_key_id               = aws_kms_key.rds_kms.arn
  publicly_accessible      = false
  auto_minor_version_upgrade = true
  depends_on               = [aws_db_instance.postgres]

  tags = {
    Name = "${var.db_identifier}-replica"
  }
}

