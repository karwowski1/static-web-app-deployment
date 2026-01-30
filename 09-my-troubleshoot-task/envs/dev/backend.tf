terraform {
  backend "s3" {
    bucket       = "my-troubleshoot-task-s3-state"
    key          = "dev/terraform.tfstate"
    region       = "eu-central-1"
    encrypt      = true
    use_lockfile = true 
  }
}