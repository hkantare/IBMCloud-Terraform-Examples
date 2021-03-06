data "ibm_compute_ssh_key" "tycho" {
  label = "ryan_tycho"
}

resource "ibm_storage_block" "blocktest" {
        depends_on = ["ibm_compute_vm_instance.blockvsitest"]
        type = "Endurance"
        datacenter = "wdc07"
        capacity = 20
        iops = 0.25
        os_format_type = "Linux"
        snapshot_capacity = 10
        hourly_billing = true
        allowed_virtual_guest_ids = ["${ibm_compute_vm_instance.blockvsitest.id}"]

    provisioner "local-exec" {
        command = "echo ${jsonencode(ibm_storage_block.blocktest.allowed_host_info)} >> ${ibm_storage_block.blocktest.id}_details.txt"
    }

    provisioner "local-exec" {
        command = "echo ${ibm_storage_block.blocktest.hostname} >> ${ibm_storage_block.blocktest.id}_hostname.txt"
    }

}

resource "ibm_compute_vm_instance" "blockvsitest" {
   hostname = "blockvsitest"
   os_reference_code = "${var.os}"
   domain = "${var.domain_name}"
   datacenter = "${var.datacenter}"
   network_speed  = 1000
   hourly_billing = true
   flavor_key_name = "${var.vm_flavor}"
   public_vlan_id = "${var.public_vlan}"
   private_vlan_id = "${var.private_vlan}"
   local_disk = false
   tags = [
     "ryantiffany",
     "terraform"
   ]
   ssh_key_ids = ["${data.ibm_compute_ssh_key.tycho.id}"]
}

resource "null_resource" "vsi_postinstall" {

 connection {
    host = "${ibm_compute_vm_instance.blockvsitest.ipv4_address}"
}

  provisioner "file" {
    source      = "mount.sh"
    destination = "/tmp/mount.sh"
}

  provisioner "file" {
      source = "initiatorname.iscsi"
      destination = "/tmp/initiatorname.iscsi"
  }

  provisioner "file" {
      source = "iscsi-example.conf"
      destination = "/tmp/iscsi-example.conf"
  }

  provisioner "file" {
    source      = "${ibm_storage_block.blocktest.id}_details.txt"
    destination = "/tmp/mountpath.txt"
}

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/mount.sh",
      "/tmp/mount.sh",
    ]
  }
}