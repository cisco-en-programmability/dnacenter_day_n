
# this plan will distribute the golden software image to the devices from the "non_compliant_devices.json" file

terraform {
  required_providers {
    dnacenter = {
      version = "0.3.0-beta"
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

# git pull to download the image non compliant devices inventory
data "github_repository_file" "non_compliant_devices" {
  repository = "dnacenter_day_n_inventory"
  branch     = "main"
  file       = "non_compliant_devices.json"
}

output "non_compliant_devices_list" {
  value       = data.github_repository_file.non_compliant_devices.content
  description = "file_content"
}

# save file to local folder
resource "local_file" "file_name" {
  filename = "non_compliant_devices.json"
  content  = data.github_repository_file.non_compliant_devices.content
}

# Configure provider with your Cisco DNA Center credentials
provider "dnacenter" {
  username   = var.DNAC_USERNAME
  password   = var.DNAC_PASSWORD
  base_url   = var.DNAC_URL
  debug      = "false"
  ssl_verify = "false"
}

# import the downloaded info, encoding in json
locals {
  # get json
  non_compliant_devices_list = jsondecode(data.github_repository_file.non_compliant_devices.content)
}

# define the software distribution module that will be called for each device
module "swim_upgrade" {
  source    = "./modules/distribution"
  count = length(local.non_compliant_devices_list)
  device_info = local.non_compliant_devices_list[count.index]
}

# output the devices hostname requiring an image upgrade
output "device_upgraded" {
  description = "Device Hostname"
  value = [for device in local.non_compliant_devices_list :
  device.hostname]
}

