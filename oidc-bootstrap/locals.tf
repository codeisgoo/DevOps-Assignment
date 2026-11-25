data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

locals {
  github_oidc_repo   = "repo:${split("/", var.github_repository)[0]}@${var.github_owner_id}/${split("/", var.github_repository)[1]}@${var.github_repository_id}"
  account_id         = data.aws_caller_identity.current.account_id
  partition          = data.aws_partition.current.partition
  ecr_arn            = "arn:${local.partition}:ecr:${var.aws_region}:${local.account_id}:repository/${var.project_name}-api"
  ssm_arn            = "arn:${local.partition}:ssm:${var.aws_region}:${local.account_id}:parameter/${var.project_name}/${var.environment}/app-message"
  execution_role_arn = "arn:${local.partition}:iam::${local.account_id}:role/${var.project_name}-ecs-execution-role"
  task_role_arn      = "arn:${local.partition}:iam::${local.account_id}:role/${var.project_name}-ecs-task-role"
  service_arn        = "arn:${local.partition}:ecs:${var.aws_region}:${local.account_id}:service/${var.project_name}-cluster/${var.project_name}-service"
}
