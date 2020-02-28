provider "aws" {
  version = "~> 2.7"
  region  = "us-east-1"
}

terraform {
  required_version = ">= 0.12"
}

module "health_check_1" {
  source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-route53//modules/health_check/?ref=v0.12.0"

  name              = "HealthCheck1"
  domain_name       = ["www.rackspace.com"]
  domain_name_count = 1
  # alarms_enabled     = true
  # alarm_evaluations  = 20
  # failure_threshold  = 5
  # notification_topic = "module.sns.topic_arn
  # port               = 8443
  # protocol           = "HTTPS"
  # rackspace_managed  = false
  # resource_path      = "/test/test.html"
  # request_interval   = 10
  # search_string      = "Rackspace"

  # tags = {
  #   Tag1 = "Value 1"
  # }
}

