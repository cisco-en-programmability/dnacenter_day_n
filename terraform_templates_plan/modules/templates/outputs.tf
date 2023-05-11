
output "dnac_template_name" {
  value = var.module_template_name
  description = "Cisco DNA Center template version"
}

output "dnac_template_id" {
  value = dnacenter_configuration_template.response.item.0.id
  description = "Cisco DNA Center template id"
}

output "dnac_template_content" {
  value = data.github_repository_file.tf_template_content.content
  description = "Cisco DNA Center template commands"
}

output "dnac_templates_details" {
  value = data.dnacenter_templates_details.response.item.0.id
}