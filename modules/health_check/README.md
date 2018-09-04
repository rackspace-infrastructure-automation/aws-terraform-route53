# aws-terraform-route53 - health_check

This module creates Route53 health checks and CloudWatch alarms for a list of fully qualified domain names.

## Basic Usage

```
module "health_check" {
 source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-route53//modules/health_check/?ref=v0.0.1"

 name = "HealthCheck1"

 domain_name       = ["mysite.com", "subdomain.mysite.com"]
 domain_name_count = 2
}
```

Full working references are available at [examples](examples)



## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| alarm_evaluations | The number of failed evaluations before the CloudWatch alarm is triggered. | string | `10` | no |
| alarms_enabled | Specifies whether cloudwatch alarms will be created for the health checks. | string | `false` | no |
| domain_name | A list of domain name or IP addresses to monitor. | list | - | yes |
| domain_name_count | The number of domain name or IP addresses to monitor. | string | - | yes |
| environment | Application environment for which this alarm being created. one of: ('Development', 'Integration', 'PreProduction', 'Production', 'QA', 'Staging', 'Test') | string | `Development` | no |
| failure_threshold | The number of consecutive health checks that an endpoint must pass or fail. | string | `3` | no |
| name | The name prefix for these resources | string | - | yes |
| notification_topic | SNS Topic ARN to use for customer notifications from CloudWatch alarms. (OPTIONAL) | string | `` | no |
| port | The port for the Route53 Healthcheck.  Omit to use the default port for the desired protocol. | string | `0` | no |
| protocol | The port for the Route53 Healthcheck.  Allowed values are HTTP, HTTPS, and TCP. | string | `HTTP` | no |
| rackspace_managed | Boolean parameter controlling if instance will be fully managed by Rackspace support teams, created CloudWatch alarms that generate tickets, and utilize Rackspace managed SSM documents. | string | `true` | no |
| request_interval | The number of seconds between the finish of one Route 53 health check request and the start of the next. | string | `30` | no |
| resource_path | Specifies HTTP path to monitor.  The path can be any value which returns an HTTP status code of 2xx or 3xx when the endpoint is healthy.  Ignored for TCP protocol. | string | `/` | no |
| search_string | If the string appears in the response body, Amazon Route 53 considers the resource healthy.  Ignored for TCP domain protocols. | string | `` | no |
| tags | Custom tags to apply to all resources. | map | `<map>` | no |

