variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-west-2"
}

variable "ecs_cluster_name" {
  description = "ECS Cluster name"
  type        = string
  default     = "eventrsvp-cluster"
}

variable "service_name" {
  description = "ECS Service name"
  type        = string
  default     = "eventrsvp-service"
}

variable "container_image" {
  description = "ECR image URI for the container"
  type        = string
  default     = "054116116033.dkr.ecr.us-west-2.amazonaws.com/eventrsvp:1.2" 
}

variable "container_port" {
  description = "Port the container listens on"
  type        = number
  default     = 8080
}

variable "desired_count" {
  description = "Number of ECS tasks to run"
  type        = number
  default     = 1
}

variable "cpu" {
  description = "CPU units for each ECS task"
  type        = number
  default     = 256
}

variable "memory" {
  description = "Memory (MB) for each ECS task"
  type        = number
  default     = 512
}

variable "max_capacity" {
  description = "Max number of ECS tasks for scaling"
  type        = number
  default     = 5
}

variable "min_capacity" {
  description = "Min number of ECS tasks for scaling"
  type        = number
  default     = 1
}
