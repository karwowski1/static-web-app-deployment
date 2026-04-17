terraform {
  backend "s3" {
    bucket       = "jenkins-pt3-tf-state-skibidi"
    key          = "envs/prod/terraform.tfstate"
    region       = "eu-central-1"
    encrypt      = true
    use_lockfile = true
  }
}
