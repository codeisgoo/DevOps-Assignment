output "api_url" {
  description = "Public URL of the API through the Application Load Balancer"
  value       = "http://${aws_lb.app.dns_name}"
}

output "ecr_repository_url" {
  description = "ECR repository URL for the API image"
  value       = aws_ecr_repository.app.repository_url
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.app.name
}

output "ecs_service_name" {
  value = aws_ecs_service.app.name
}

output "github_actions_role_arn" {
  description = "Use this ARN in GitHub Actions to assume the deployment role with OIDC"
  value       = aws_iam_role.github_actions.arn
}

output "sns_topic_arn" {
  value = aws_sns_topic.alerts.arn
}
