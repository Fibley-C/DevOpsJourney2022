terraform {
  required_providers {
    hyperv = {
      source = "taliesins/hyperv"
      version = "1.0.3"
    }
  }
}

resource "hyperv_network_switch" "v_switch" {
  name = "switch01"
  allow_management_os = true
  switch_type = "Internal"
}

resource "hyperv_vhd" "control_vhd" {
  path = "C:\\Users\\Public\\Documents\\Hyper-V\\Virtual Hard Disks\\control_vm.vhdx"
  vhd_type = "Fixed"
  size = 1342177280
}

resource "hyperv_machine_instance" "control_vm" {
    name = "control"
    static_memory = true
    memory_startup_bytes = 536870912
    processor_count = 1

    network_adaptors {
        name = "Eth01"
        switch_name = "${hyperv_network_switch.v_switch.name}"
    }

    hard_disk_drives {
        controller_type = "Scsi"
        controller_number = "0"
        controller_location = "0"
        path = "${hyperv_vhd.control_vhd.path}"
    }
}

# resource "hyperv_machine_instance" "node1_vm" {
#     name = "node1"
# }

# resource "hyperv_machine_instance" "node2_vm" {
#     name = "node2"
# }

# resource "hyperv_machine_instance" "node3_vm" {
#     name = "node3"
# }