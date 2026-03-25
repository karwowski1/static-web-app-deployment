module "ec2" {
  source = "../../modules/ec2"
}

module "cloudwatch" {
  source             = "../../modules/cloudwatch"
  web_instance_id    = module.ec2.web_instance_id
  api_instance_id    = module.ec2.api_instance_id
  worker_instance_id = module.ec2.worker_instance_id
}
