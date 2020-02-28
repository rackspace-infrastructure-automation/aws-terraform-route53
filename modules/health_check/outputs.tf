output "healthcheck_id" {
  description = "Healthcheck ID"
  value       = aws_route53_health_check.health_check.*.id
}

