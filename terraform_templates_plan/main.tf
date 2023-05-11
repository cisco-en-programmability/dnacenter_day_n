
# this plan will create or update Cisco DNA Center projects and templates

terraform {
  required_providers {
    dnacenter = {
      version = "1.1.6-beta"
      source  = "cisco-en-programmability/dnacenter"
    }
    github = {
      source  = "integrations/github"
      version = "~> 4.0"
    }
  }
}

provider "github" {
  token = var.GITHUB_TOKEN
}

variable "github_repo_name" {
  type        = string
  description = "The repo hosting the project info - input variable"
  default = "dnacenter_terraform_templates"
}

variable "project_file_name" {
  type        = string
  description = "The name of file with the project details, JSON formatted - input variable"
  default = "project_info.json"
}

# git pull to download the file with the project details
# file will include the Cisco DNA Center project name, and the list of template names to be created/updated
data "github_repository_file" "tf_project_info" {
  repository = var.github_repo_name
  branch     = "master"
  file       = var.project_file_name
}

# save project details from GitHub to file in local folder
resource "local_file" "project_file_name" {
  filename = var.project_file_name
  content  = data.github_repository_file.tf_project_info.content
}

output "github_project_info" {
  value       = local.project_info_json
  description = "project info pulled from GitHub"
}

# retrieve the template name, parse the JSON input from GitHub
locals {
  # get json
  project_info_json = jsondecode(data.github_repository_file.tf_project_info.content)
}

output "dnac_project_name" {
  value       = local.project_info_json.project_name
  description = "Cisco DNA Center project name"
}

output "dnac_templates" {
  value       = local.project_info_json.templates
  description = "Cisco DNA Center template names (list)"
}

/*
# git pull to download the template content
data "github_repository_file" "tf_template_content" {
  repository = var.github_repo_name
  branch     = "master"
  file       = local.project_info_json.templates.0
}

output "dnac_template_content" {
  value       = data.github_repository_file.tf_template_content.content
  description = "Content of the CLI template"
}
*/

output "templates_count" {
  value = length(local.project_info_json.templates)
  description = "Number of templates in the project"
}

# Configure provider with your Cisco DNA Center credentials
provider "dnacenter" {
  username   = var.DNAC_USERNAME
  password   = var.DNAC_PASSWORD
  base_url   = var.DNAC_URL
  debug      = "false"
  ssl_verify = "false"
}

# Retrieve project's templates
data "dnacenter_configuration_template_project" "response" {
  provider = dnacenter
  name     = "Terraform_Project"
}

output "dnac_project_id" {
  value       = data.dnacenter_configuration_template_project.response.items.0.id
  description = "Cisco DNA Center project id"
}

# define the create template module that will be called for each template in the list
module "create_template" {
  source    = "./modules/templates"
  module_project_name = local.project_info_json.project_name
  module_project_id = data.dnacenter_configuration_template_project.response.items.0.id
  module_github_repo_name = var.github_repo_name
  for_each = local.project_info_json.templates
    module_template_name = each.value
}

output "dnac_template_info" {
  value = (module.create_template)
  description = "Cisco DNA Center template details"
}
