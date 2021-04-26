# aws-terraform-route53 - health\_check

This module creates Route53 health checks and CloudWatch alarms for a list of fully qualified domain names.

## Basic Usage

```
module "health_check" {
  source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-route53//modules/health_check/?ref=v0.12.0"

 domain_name       = ["mysite.com", "subdomain.mysite.com"]
 domain_name_count = 2
 name              = "HealthCheck1"

}
```

Full working references are available at [examples](examples)

## Other TF Modules Used  
Using [aws-terraform-cloudwatch\_alarm](https://github.com/rackspace-infrastructure-automation/aws-terraform-cloudwatch_alarm) to create the following CloudWatch Alarms:
	- health\_check\_alarms

## Terraform 0.12 upgrade

There should be no changes required to move from previous versions of this module to version 0.12.0 or higher.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |
| aws | >= 2.7.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.7.0 |
| null | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| health_check_alarms | git@github.com:rackspace-infrastructure-automation/aws-terraform-cloudwatch_alarm//?ref=v0.12.6 |  |

## Resources

| Name |
|------|
| [aws_route53_health_check](https://registry.terraform.io/providers/hashicorp/aws/2.7.0/docs/resources/route53_health_check) |
| [null_data_source](https://registry.terraform.io/providers/hashicorp/null/latest/docs/data-sources/data_source) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| alarm\_evaluations | The number of failed evaluations before the CloudWatch alarm is triggered. | `string` | `10` | no |
| domain\_name | A list of domain name or IP addresses to monitor. | `list(string)` | n/a | yes |
| domain\_name\_count | The number of domain name or IP addresses to monitor. | `string` | n/a | yes |
| environment | Application environment for which this alarm being created. one of: ('Development', 'Integration', 'PreProduction', 'Production', 'QA', 'Staging', 'Test') | `string` | `"Development"` | no |
| failure\_threshold | The number of consecutive health checks that an endpoint must pass or fail. | `string` | `3` | no |
| name | The name prefix for these resources | `string` | n/a | yes |
| notification\_topic | List of SNS Topic ARNs to use for customer notifications. | `list(string)` | `[]` | no |
| port | The port for the Route53 Healthcheck.  Omit to use the default port for the desired protocol. | `number` | `0` | no |
| protocol | The port for the Route53 Healthcheck.  Allowed values are HTTP, HTTPS, and TCP. | `string` | `"HTTP"` | no |
| rackspace\_alarms\_enabled | Specifies whether alarms will create a Rackspace ticket.  Ignored if rackspace\_managed is set to false. | `string` | `false` | no |
| rackspace\_managed | Boolean parameter controlling if instance will be fully managed by Rackspace support teams, created CloudWatch alarms that generate tickets, and utilize Rackspace managed SSM documents. | `string` | `true` | no |
| request\_interval | The number of seconds between the finish of one Route 53 health check request and the start of the next. | `string` | `30` | no |
| resource\_path | Specifies HTTP path to monitor.  The path can be any value which returns an HTTP status code of 2xx or 3xx when the endpoint is healthy.  Ignored for TCP protocol. | `string` | `"/"` | no |
| search\_string | If the string appears in the response body, Amazon Route 53 considers the resource healthy.  Ignored for TCP domain protocols. | `string` | `""` | no |
| tags | Custom tags to apply to all resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| healthcheck\_id | Healthcheck ID |
