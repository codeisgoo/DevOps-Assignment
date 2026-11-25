# Application infrastructure
Terraform >= 1.10, AWS CLI credentials, private versioned S3 bucket devops-assignment-tfstatefile. GitHub OIDC is managed separately in oidc-bootstrap; follow its migration instructions before applying or destroying an existing stack.

Run locally: terraform init, terraform fmt -recursive, terraform validate, terraform plan, terraform apply. Review plans before applying. Commit the generated .terraform.lock.hcl. The supplied tfvars contains non-secret settings; alarm_email is blank for privacy. Restore your existing email locally or use TF_VAR_alarm_email after removing the explicit tfvars value. If you keep it blank, Terraform will plan removal of the email subscription; SNS topic and alarm remain. Never commit state, plan files or credentials.

Initial ECS desired count is zero. CD pushes the image and starts one task; Terraform ignores subsequent service task definition and desired count changes. For manual start after pushing latest, use aws ecs update-service --region us-east-1 --cluster devops-assignment-cluster --service devops-assignment-service --desired-count 1. Test terraform output -raw api_url with /health and /items. CPU scaling cannot wake from zero; set minimum to 1 for a continuously available service after deploying.

Cleanup: empty the ECR repository of images if needed, then terraform destroy from this directory only. OIDC roles and provider remain. NAT, ALB, IPv4 and Fargate can incur charges; check credits and billing. The S3 state bucket is retained separately.
