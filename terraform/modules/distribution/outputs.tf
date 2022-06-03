
output "dnacenter_image_distribution_task_id" {
  description = "Software distribution task id"
  value       = dnacenter_image_distribution.response.item[0].task_id
}

output "dnacenter_image_distribution_task_output" {
  description = "Software distribution task result"
  value       = data.dnacenter_task.response.item[0].progress
}
