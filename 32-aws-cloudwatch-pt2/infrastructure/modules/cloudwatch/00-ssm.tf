resource "aws_ssm_parameter" "cw_agent_config" {
  name        = "AmazonCloudWatch-Config"
  description = "CloudWatch Agent configuration for EC2 instances"
  type        = "String"

  value = jsonencode({
    agent = {
      metrics_collection_interval = 60
      run_as_user                 = "root"
    }
    metrics = {
      metrics_collected = {
        cpu = {
          measurement                 = ["cpu_usage_idle", "cpu_usage_iowait"]
          metrics_collection_interval = 60
          totalcpu                    = true
        }
        disk = {
          measurement                 = ["used_percent"]
          metrics_collection_interval = 60
          resources                   = ["*"]
        }
        net = {
          measurement                 = ["bytes_sent"]
          metrics_collection_interval = 60
        }
      }
    }
  })
}

# installing the agent on all EC2 instances with tag Env=prod
resource "aws_ssm_association" "install_cw_agent" {
  name = "AWS-ConfigureAWSPackage"

  targets {
    key    = "tag:Env"
    values = ["prod"]
  }

  parameters = {
    action = "Install"
    name   = "AmazonCloudWatchAgent"
  }
}

# configuring the agent on all EC2 instances with tag Env=prod, using the configuration from SSM Parameter Store
resource "aws_ssm_association" "configure_cw_agent" {
  name = "AmazonCloudWatch-ManageAgent"

  targets {
    key    = "tag:Env"
    values = ["prod"]
  }

  parameters = {
    action                        = "configure"
    mode                          = "ec2"
    optionalConfigurationSource   = "ssm"
    optionalConfigurationLocation = aws_ssm_parameter.cw_agent_config.name
    optionalRestart               = "yes"
  }

  depends_on = [aws_ssm_association.install_cw_agent]
}
