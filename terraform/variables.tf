variable "aws_region" {
  description = "AWS region for all resources"
  type        = string
}

variable "project_name" {
  description = "Short project name used in resource names"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR range"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDR ranges for the two public subnets"
  type        = list(string)

  validation {
    condition     = length(var.public_subnet_cidrs) == 2
    error_message = "Provide exactly two public subnet CIDR ranges."
  }
}

variable "private_subnet_cidrs" {
  description = "CIDR ranges for the two private subnets"
  type        = list(string)

  validation {
    condition     = length(var.private_subnet_cidrs) == 2
    error_message = "Provide exactly two private subnet CIDR ranges."
  }
}

variable "container_port" {
  description = "Port exposed by the Node.js API"
  type        = number
  default     = 3000
}

variable "container_cpu" {
  description = "Fargate task CPU units"
  type        = number
  default     = 256
}

variable "container_memory" {
  description = "Fargate task memory in MiB"
  type        = number
  default     = 512
}

variable "desired_count" {
  description = "Number of running ECS tasks; use 0 for the first infrastructure apply before pushing the image"
  type        = number
  default     = 0
}

variable "image_tag" {
  description = "Container image tag stored in ECR"
  type        = string
  default     = "latest"
}

variable "app_message" {
  description = "Application message stored in SSM Parameter Store"
  type        = string
  default     = "Running in AWS ECS Fargate"
}

variable "log_retention_days" {
  description = "CloudWatch log retention period"
  type        = number
  default     = 7
}

variable "alarm_email" {
  description = "Optional email address for CloudWatch alarm notifications"
  type        = string
  default     = ""
}

variable "autoscaling_min_capacity" {
  description = "Minimum ECS tasks; keep 0 until the image is pushed, then set 1"
  type        = number
  default     = 0
}

variable "autoscaling_max_capacity" {
  description = "Maximum ECS tasks"
  type        = number
  default     = 3
}

variable "autoscaling_cpu_target" {
  description = "Target average ECS CPU utilization percentage"
  type        = number
  default     = 60
}