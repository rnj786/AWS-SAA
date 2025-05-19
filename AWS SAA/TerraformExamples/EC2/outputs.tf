output "instance_id" {
  description = "ID of the created EC2 instance"
  value       = aws_instance.ec2_instance.id
}

output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.ec2_instance.public_ip
}

output "security_group_id" {
  description = "ID of the created Security Group"
  value       = aws_security_group.ec2_sg.id
}

output "key_pair_name" {
  description = "Name of the created Key Pair"
  value       = aws_key_pair.key_pair.key_name
}

output "kms_key_arn" {
  description = "ARN of the created KMS Key"
  value       = aws_kms_key.ebs_kms_key.arn
}

output "kms_key_id" {
  description = "ID of the created KMS Key"
  value       = aws_kms_key.ebs_kms_key.key_id
}