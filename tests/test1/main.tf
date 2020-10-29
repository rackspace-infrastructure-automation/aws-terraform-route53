
terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  version = "~> 3.0"
  region  = "us-west-2"
}

module "health_check_1" {
  source = "../../module/modules/health_check/"

  name              = "HealthCheck1"
  domain_name       = ["www.rackspace.com", "bad_site.rackspace.com"]
  domain_name_count = 2
}
