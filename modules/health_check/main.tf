/**
* # aws-terraform-route53/modules/health_check
*
*This module creates Route53 health checks and CloudWatch alarms for a list of fully qualified domain names.
*
*## Basic Usage
*
*```
*module "health_check" {
*  source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-route53//modules/health_check/?ref=v0.0.1"
*
*  name = "HealthCheck1"

*  domain_name       = ["mysite.com", "subdomain.mysite.com"]
*  domain_name_count = 2
*}
*```
*
* Full working references are available at [examples](examples)
*
*/

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

locals {
  rs_alarm_topic         = ["arn:aws:sns:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:rackspace-support-urgent"]
  alarm_sns_notification = "${compact(list(var.notification_topic))}"
  rs_alarm_option        = "${var.rackspace_managed ? "managed" : "unmanaged"}"

  rs_alarm_action = {
    managed   = "${local.rs_alarm_topic}"
    unmanaged = "${local.alarm_sns_notification}"
  }

  rs_ok_action = {
    managed   = "${local.rs_alarm_topic}"
    unmanaged = []
  }

  healthcheck_type = "${upper(var.protocol)}${var.search_string == "" && upper(var.protocol) != "TCP" ? "" : "_STR_MATCH"}"
  default_port     = "${upper(var.protocol) == "HTTPS" ? 443 : 80}"

  tags {
    ServiceProvider = "Rackspace"
    Environment     = "${var.environment}"
  }
}

resource "aws_route53_health_check" "health_check" {
  count = "${var.domain_name_count}"

  failure_threshold = "${var.failure_threshold}"
  fqdn              = "${element(var.domain_name, count.index)}"
  measure_latency   = true
  port              = "${var.port != 0 ? var.port : local.default_port }"
  request_interval  = "${var.request_interval}"
  resource_path     = "${upper(var.protocol) != "TCP" ? var.resource_path : ""}"
  search_string     = "${upper(var.protocol) != "TCP" ? var.search_string : ""}"
  type              = "${local.healthcheck_type}"

  tags = "${merge(
    map("Name", "${var.name} - ${element(var.domain_name, count.index)}"),
    local.tags,
    var.tags
  )}"
}

resource "aws_cloudwatch_metric_alarm" "health_check_alarms" {
  count = "${var.alarms_enabled ? var.domain_name_count : 0}"

  alarm_name          = "${var.name}-${element(var.domain_name, count.index)}-Alarm"
  alarm_actions       = ["${local.rs_alarm_action[local.rs_alarm_option]}"]
  alarm_description   = "${element(var.domain_name, count.index)} has failed."
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "${var.alarm_evaluations}"
  metric_name         = "HealthCheckStatus"
  namespace           = "AWS/Route53"
  ok_actions          = ["${local.rs_ok_action[local.rs_alarm_option]}"]
  period              = "60"
  statistic           = "Minimum"
  threshold           = "1"

  dimensions {
    HealthCheckId = "${element(aws_route53_health_check.health_check.*.id, count.index)}"
  }
}
