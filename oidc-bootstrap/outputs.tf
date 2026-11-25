output "github_ci_role_arn" {
  value = aws_iam_role.github_ci.arn
}

output "github_actions_role_arn" {
  value = aws_iam_role.github_actions.arn
}
