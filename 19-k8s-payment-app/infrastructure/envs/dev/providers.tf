terraform {
  backend "s3" {
    bucket       = "finpay-tf-state-k8s-payment-app"
    key          = "envs/dev/terraform.tfstate"
    region       = "eu-central-1"
    encrypt      = true
    
    use_lockfile = true
  }
}