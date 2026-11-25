# AWS DevOps Assignment – Terraform

This Terraform configuration creates the infrastructure required by the assignment:

- VPC across two Availability Zones, with public and private subnets
- Internet Gateway and one NAT Gateway
- Public Application Load Balancer
- ECS Fargate service in private subnets
- ECR repository for the API image, with image scanning on push
- SSM Parameter Store application setting injected into the container
- Separate ECS task and task execution IAM roles
- CloudWatch log group with configurable retention
- CloudWatch ALB 5xx alarm and SNS topic/email subscription
- GitHub Actions OIDC provider and a repository-restricted deployment role

## Important cost warning

This is real AWS infrastructure and is **not zero-cost**. The Application Load Balancer, NAT Gateway, NAT public IPv4 address, Fargate tasks, and data transfer can incur charges. The initial deployment uses `desired_count = 0` so you can create the infrastructure and ECR repository before pushing the application image. Set `desired_count = 1` only after the image is pushed.

When finished testing, run `terraform destroy` to remove the resources. Check the AWS billing console as well.

## 1. Prerequisites

- Terraform 1.9 or newer
- AWS CLI configured with credentials that can create the listed AWS resources
- Docker
- Your Part 1 Node.js API in the `app/` directory
- A GitHub repository for the assignment

Run:

```bash
aws sts get-caller-identity
terraform version
docker version
```

## 2. Configure Terraform

From this directory:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` and replace:

- `github_repository` with `YOUR_GITHUB_USERNAME/YOUR_REPOSITORY`
- `alarm_email` with an email address if you want email notifications; leave it empty to skip email subscription

Review the AWS region and CIDR values. Do not commit `terraform.tfvars`.

## 3. Create infrastructure and ECR repository

Run these commands from the `terraform/` directory:

```bash
terraform init
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
```

The first apply creates the ECR repository and AWS infrastructure, but the ECS service desired count is zero. This avoids ECS trying to start an image that has not been pushed yet.

If you set `alarm_email`, AWS sends a subscription confirmation email. Confirm it to receive alarm notifications.

## 4. Build and push the API image

Run these commands from the assignment repository root (the directory containing both `app/` and `terraform/`). Set `AWS_REGION` to the same region configured in `terraform/terraform.tfvars`:

```bash
AWS_REGION=us-east-1
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
ECR_REPO=$(cd terraform && terraform output -raw ecr_repository_url)
IMAGE="$ECR_REPO:latest"

aws ecr get-login-password --region "$AWS_REGION"   | docker login --username AWS --password-stdin "$ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com"

docker build -t "$IMAGE" ./app
docker push "$IMAGE"
```

## 5. Start the ECS task

Edit `terraform.tfvars` and change:

```hcl
desired_count = 1
```

Then run:

```bash
terraform apply
```

Get the API URL:

```bash
cd terraform
terraform output api_url
```

Test it:

```bash
API_URL=$(terraform output -raw api_url)
curl "$API_URL/health"
curl "$API_URL/items"
```

## 6. GitHub Actions OIDC

After the first Terraform apply, get the deployment role ARN:

```bash
cd terraform
terraform output -raw github_actions_role_arn
```

Add these GitHub Actions repository variables:

- `AWS_ROLE_ARN`: output above
- `AWS_REGION`: your configured region
- `ECR_REPOSITORY`: output of `terraform output -raw ecr_repository_url`
- `ECS_CLUSTER`: output of `terraform output -raw ecs_cluster_name`
- `ECS_SERVICE`: output of `terraform output -raw ecs_service_name`

The IAM trust policy only allows the configured GitHub repository's `main` branch to assume the role. The role can push to this ECR repository and update the ECS service. The GitHub Actions workflow must request `id-token: write` and `contents: read`.

If your AWS account already has the GitHub Actions OIDC provider, Terraform may report that the provider URL already exists. In that case, import the existing provider into Terraform state rather than creating a duplicate:

```bash
terraform import aws_iam_openid_connect_provider.github arn:aws:iam::<ACCOUNT_ID>:oidc-provider/token.actions.githubusercontent.com
```

## 7. Terraform remote state (S3)

The assignment accepts a clear setup note for remote state. This folder uses local state by default so it can be initialized immediately.

For a shared/team deployment, create a dedicated S3 bucket with versioning and encryption, then:

1. Copy `backend.tf.example` to `backend.tf`.
2. Replace the bucket name and region.
3. Run `terraform init -migrate-state`.

The S3 backend uses `use_lockfile = true` for state locking. Keep the state bucket private and enable S3 public access blocking.

## 8. Cleanup

To avoid ongoing AWS charges:

```bash
terraform destroy
```

Run it from this directory after testing. Confirm the resources are deleted in the AWS console.
