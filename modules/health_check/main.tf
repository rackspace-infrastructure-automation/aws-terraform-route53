/*
* # aws-terraform-route53 - health_check
*
* This module creates Route53 health checks and CloudWatch alarms for a list of fully qualified domain names.
*
* ## Basic Usage
*
* ```
* module "health_check" {
*   source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-route53//modules/health_check/?ref=v0.12.0"
*
*  domain_name       = ["mysite.com", "subdomain.mysite.com"]
*  domain_name_count = 2
*  name              = "HealthCheck1"
*
* }
* ```
*
* Full working references are available at [examples](examples)
*
* ## Other TF Modules Used
* Using [aws-terraform-cloudwatch_alarm](https://github.com/rackspace-infrastructure-automation/aws-terraform-cloudwatch_alarm) to create the following CloudWatch Alarms:
* 	- health_check_alarms
*
* ## Terraform 0.12 upgrade
*
* There should be no changes required to move from previous versions of this module to version 0.12.0 or higher.
*/

terraform {
  required_version = ">= 0.12"
}

locals {
  default_port     = upper(var.protocol) == "HTTPS" ? 443 : 80
  healthcheck_type = "${upper(var.protocol)}${var.search_string == "" && upper(var.protocol) != "TCP" ? "" : "_STR_MATCH"}"

  tags = {
    Environment     = var.environment
    ServiceProvider = "Rackspace"
  }
}

data "null_data_source" "hc_name_tag" {
  count = var.domain_name_count

  inputs = {
    Name = "${var.name} - ${element(var.domain_name, count.index)}"
  }
}

resource "aws_route53_health_check" "health_check" {
  count = var.domain_name_count

  failure_threshold = var.failure_threshold
  fqdn              = element(var.domain_name, count.index)
  measure_latency   = true
  port              = var.port != 0 ? var.port : local.default_port
  request_interval  = var.request_interval
  resource_path     = upper(var.protocol) != "TCP" ? var.resource_path : ""
  search_string     = upper(var.protocol) != "TCP" ? var.search_string : ""
  type              = local.healthcheck_type

  tags = merge(
    data.null_data_source.hc_name_tag[count.index].outputs,
    local.tags,
    var.tags,
  )
}

data "null_data_source" "alarm_dimensions" {
  count = var.domain_name_count

  inputs = {
    HealthCheckId = element(aws_route53_health_check.health_check.*.id, count.index)
  }
}

module "health_check_alarms" {
  source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-cloudwatch_alarm//?ref=v0.12.1"

  alarm_count              = var.domain_name_count
  alarm_description        = "Domain healthcheck has failed."
  comparison_operator      = "LessThanThreshold"
  dimensions               = data.null_data_source.alarm_dimensions.*.outputs
  evaluation_periods       = var.alarm_evaluations
  metric_name              = "HealthCheckStatus"
  name                     = "${var.name}-R53-HealthCheck-Alarm"
  namespace                = "AWS/Route53"
  notification_topic       = var.notification_topic
  period                   = 60
  rackspace_alarms_enabled = var.rackspace_alarms_enabled
  rackspace_managed        = var.rackspace_managed
  severity                 = "urgent"
  statistic                = "Minimum"
  threshold                = 1
}

