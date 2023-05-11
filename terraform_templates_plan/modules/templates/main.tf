
# this is module will be called, once for every template to be created/updated/destroyed
terraform {
  required_version = ">= 1.2.0"
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

variable "module_project_name" {
  description = "Project details - Cisco DNA Center project name"
  type = string
}

variable "module_template_name" {
  description = "Project details - Cisco DNA Center template name"
  type = string
}

variable "module_project_id" {
  description = "Project Details - Cisco DNA Center project Id"
  type = string
}

variable "module_github_repo_name" {
  description = "GitHub repo name"
  type = string
}

# git pull to download the template content
data "github_repository_file" "tf_template_content" {
  repository = var.module_github_repo_name
  branch     = "master"
  file       = var.module_template_name
}

# save file to local folder, file name is the template name from GitHub
resource "local_file" "template_file" {
  filename = var.module_template_name
  content  = data.github_repository_file.tf_template_content.content
}

# update or create a new template
resource "dnacenter_configuration_template" "response" {
  provider = dnacenter
  parameters {
    name = var.module_template_name
    author =  "Terraform"
    description = "GitHub hosted template"
    device_types {
      product_family = "Switches and Hubs"
    }
    software_type = "IOS-XE"
    software_variant = "XE"
    template_content = data.github_repository_file.tf_template_content.content
    project_id = var.module_project_id
    project_name = var.module_project_name
    language = "JINJA"
  }
}


# get the template details
data "dnacenter_templates_details" "response" {
  provider                     = dnacenter
  id                           = var.module_project_id
  name                         = var.module_template_name
  depends_on = [dnacenter_configuration_template.response]
}

/*
# version (commit) the template, optional
resource "dnacenter_configuration_template_version" "response" {
  provider = dnacenter
  parameters {
    comments = "Pulled from GitHub, committed by Terraform"
    template_id = dnacenter_configuration_template.response.item.0.id
  }
}
*/