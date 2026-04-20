terraform {
  backend "s3" {
    bucket       = "jenkins-pt4-tf-state-skibidi"
    key          = "jenkins-platform/terraform.tfstate"
    region       = "eu-central-1"
    encrypt      = true
    use_lockfile = true
  }
}
