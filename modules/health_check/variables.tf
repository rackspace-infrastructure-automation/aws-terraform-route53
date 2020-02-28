variable "alarm_evaluations" {
  description = "The number of failed evaluations before the CloudWatch alarm is triggered."
  type        = "string"
  default     = 10
}

variable "domain_name" {
  description = "A list of domain name or IP addresses to monitor."
  type        = "list"
}

variable "domain_name_count" {
  description = "The number of domain name or IP addresses to monitor."
  type        = "string"
}

variable "environment" {
  description = "Application environment for which this alarm being created. one of: ('Development', 'Integration', 'PreProduction', 'Production', 'QA', 'Staging', 'Test')"
  type        = "string"
  default     = "Development"
}

variable "failure_threshold" {
  description = "The number of consecutive health checks that an endpoint must pass or fail."
  type        = "string"
  default     = 3
}

variable "name" {
  description = "The name prefix for these resources"
  type        = "string"
}

variable "notification_topic" {
  description = "List of SNS Topic ARNs to use for customer notifications."
  type        = "list"
  default     = []
}

variable "port" {
  description = "The port for the Route53 Healthcheck.  Omit to use the default port for the desired protocol."
  type        = "string"
  default     = 0
}

variable "protocol" {
  description = "The port for the Route53 Healthcheck.  Allowed values are HTTP, HTTPS, and TCP."
  type        = "string"
  default     = "HTTP"
}

variable "rackspace_alarms_enabled" {
  description = "Specifies whether alarms will create a Rackspace ticket.  Ignored if rackspace_managed is set to false."
  type        = "string"
  default     = false
}

variable "rackspace_managed" {
  description = "Boolean parameter controlling if instance will be fully managed by Rackspace support teams, created CloudWatch alarms that generate tickets, and utilize Rackspace managed SSM documents."
  type        = "string"
  default     = true
}

variable "request_interval" {
  description = "The number of seconds between the finish of one Route 53 health check request and the start of the next."
  type        = "string"
  default     = 30
}

variable "resource_path" {
  description = "Specifies HTTP path to monitor.  The path can be any value which returns an HTTP status code of 2xx or 3xx when the endpoint is healthy.  Ignored for TCP protocol."
  type        = "string"
  default     = "/"
}

variable "search_string" {
  description = "If the string appears in the response body, Amazon Route 53 considers the resource healthy.  Ignored for TCP domain protocols."
  type        = "string"
  default     = ""
}

variable "tags" {
  description = "Custom tags to apply to all resources."
  type        = "map"
  default     = {}
}
