terraform {
  backend "s3" {
    bucket       = "devops-assignment-tfstatefile"
    key          = "devops-assignment/oidc-bootstrap.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
