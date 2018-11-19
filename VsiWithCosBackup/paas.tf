variable "coscreds" {
  type = "map"

  default = {
    "HMAC" = true
  }
}

resource "ibm_resource_instance" "cos" {
  name     = "tfcostest"
  service  = "cloud-object-storage"
  plan     = "lite"
  location = "global"
}

resource "ibm_resource_key" "serviceKey" {
  name = "coskey"

  parameters = "${var.coscreds}"

  resource_instance_id = "${ibm_resource_instance.cos.id}"

  role = "Viewer"

  provisioner "local-exec" {
    command = "rm -f tfcostest.out"
  }

  provisioner "local-exec" {
    command = "bx resource service-key coskey > tfcostest.out"
  }
}
