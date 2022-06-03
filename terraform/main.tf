
# this plan will distribute the golden software image to the devices from the "non_compliant_devices.json" file

terraform {
  required_providers {
    dnacenter = {
      version = "0.3.0-beta"
      source  = "cisco-en-programmability/dnacenter"
    }
  }
}

# Configure provider with your Cisco DNA Center SDK credentials
provider "dnacenter" {
  username   = var.DNAC_USERNAME
  password   = var.DNAC_PASSWORD
  base_url   = var.DNAC_URL
  debug      = "false"
  ssl_verify = "false"
}

# import the non compliant devices list from the local folder
locals {
  # get json
  non_compliant_devices_list = jsondecode(file("../inventory/non_compliant_devices.json"))
}

# define the software distribution module that will be called for each device
module "swim_upgrade" {
  source    = "./modules/distribution"
  count = length(local.non_compliant_devices_list)
  device_info = local.non_compliant_devices_list[count.index]
}

# output the devices hostname requiring an image upgradeterr
output "device_upgraded" {
  description = "Device Hostname"
  value = [for device in local.non_compliant_devices_list :
  device.hostname]
}

