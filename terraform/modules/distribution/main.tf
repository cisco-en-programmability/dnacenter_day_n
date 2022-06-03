
# this is module will be called, once for every device that needs to be upgraded
terraform {
  required_version = ">= 1.2.0"
  required_providers {
    dnacenter = {
      version = "0.3.0-beta"
      source  = "cisco-en-programmability/dnacenter"
    }
  }
}

variable "device_info" {
  description = "Device UUIDs to be upgraded"
  type        = map(string)
}

# use the image distribution resource, provide the device uuid
resource "dnacenter_image_distribution" "response" {
  provider = dnacenter
  lifecycle {
    create_before_destroy = true
  }
  parameters {
    payload {
      device_uuid = var.device_info.device_id
    }
  }
}

# verify the software distribution task status
data "dnacenter_task" "response" {
  depends_on = [dnacenter_image_distribution.response]
  provider   = dnacenter
  task_id    = dnacenter_image_distribution.response.item[0].task_id
}

