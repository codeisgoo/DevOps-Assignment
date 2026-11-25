# GitHub OIDC bootstrap
Run locally with your AWS administrator credentials, not from CI. Uses a separate S3 state key. Existing S3 bucket must remain private and versioned. Keep the GitHub ci-plan environment protected with trusted reviewers; do not allow untrusted PR code to receive AWS credentials.

## Existing deployment: migrate without deleting IAM
Stop concurrent Terraform runs and pause GitHub workflows. Replace application Terraform files with the supplied application ZIP, retaining the existing local tfvars email if desired. Do not apply or destroy yet. From the repository root:

```bash
cd terraform
terraform init
umask 077
terraform state pull > ../application-state-before-split.json
cd ../oidc-bootstrap
terraform init
ACCOUNT=$(aws sts get-caller-identity --query Account --output text)
terraform import aws_iam_openid_connect_provider.github "arn:aws:iam::$ACCOUNT:oidc-provider/token.actions.githubusercontent.com"
terraform import aws_iam_role.github_ci devops-assignment-github-ci-role
terraform import aws_iam_role.github_actions devops-assignment-github-actions-role
terraform import aws_iam_role_policy.github_ci devops-assignment-github-ci-role:devops-assignment-github-ci-policy
terraform import aws_iam_role_policy.github_actions devops-assignment-github-actions-role:devops-assignment-github-deploy-policy
terraform state list
```
Verify all five imports succeeded before continuing. If any fail, stop. Then remove ONLY the old state ownership (not AWS resources):

```bash
cd ../terraform
terraform state rm aws_iam_openid_connect_provider.github aws_iam_role.github_ci aws_iam_role.github_actions aws_iam_role_policy.github_ci aws_iam_role_policy.github_actions
cd ../oidc-bootstrap
terraform fmt -recursive
terraform validate
terraform plan -out=bootstrap.tfplan
```
Review: no IAM deletion/replacement expected. Apply the reviewed plan:

```bash
terraform apply bootstrap.tfplan
terraform output
cd ../terraform
terraform fmt -recursive
terraform validate
terraform plan
```
Verify no GitHub IAM changes in application plan. Apply only intended changes. Never commit the state backup or plan; delete the local backup securely after verifying migration. Resume workflows. Existing role ARNs and GitHub variables remain unchanged.

## Fresh account
Create the private versioned S3 backend bucket first, then run terraform init, fmt, validate, plan and apply in this directory. If the OIDC provider already exists, import it rather than creating a duplicate. Then apply the application stack separately.

GitHub variables: AWS_CI_ROLE_ARN = github_ci_role_arn output; AWS_DEPLOY_ROLE_ARN = github_actions_role_arn output. CI uses environment ci-plan; CD uses main branch without an environment. The immutable subject IDs are specific to this repository. Keep bootstrap state and application state separate. Do not destroy bootstrap during app cleanup. When permanently retiring the project, remove bootstrap only after verifying no other projects use its OIDC provider.
