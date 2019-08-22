variable ibm_bx_api_key {}
variable ibm_sl_username {}
variable ibm_sl_api_key {}

variable public_vlan {
    default = 1892917
}

variable private_vlan {
    default = 1892939
}

variable domain_name { 
    default = "cde.services"
}

variable datacenter {
    default = "dal13"
}

variable vm_flavor {
  default = "B1_2X4X100"
}

variable os {
  default = "UBUNTU_LATEST_64"
}
