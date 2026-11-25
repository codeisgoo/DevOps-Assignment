# General configuration
aws_region   = "us-east-1"
project_name = "devops-assignment"
environment  = "dev"

# Networking configuration
vpc_cidr             = "10.0.0.0/16"
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]

# ECS Fargate configuration
container_port   = 3000
container_cpu    = 256
container_memory = 512
desired_count    = 0
image_tag        = "latest"

# Application configuration
app_message = "Running in AWS ECS Fargate"

# Monitoring configuration
log_retention_days = 7
alarm_email        = "shahnawazusama@gmail.com"

# GitHub Actions OIDC configuration
github_repository = "codeisgoo/DevOps-Assignment"


# Autoscaling policy

autoscaling_min_capacity = 0
autoscaling_max_capacity = 3
autoscaling_cpu_target   = 60