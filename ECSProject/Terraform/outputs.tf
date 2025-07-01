output "ecs_service_name" {
  value = aws_ecs_service.main.name
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.main.name
}

output "alb_dns_name" {
  value = aws_lb.main.dns_name
}

output "api_gateway_url" {
  value = aws_apigatewayv2_api.http_api.api_endpoint
}
