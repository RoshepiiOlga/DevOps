variable "base_ova_filename" {
  type    = string
  default = "debian-local.ova"
  description = "The local copy of of the machine image (OVA) to use for the server."

  # https://www.packer.io/docs/templates/hcl_templates/functions/string/regex
  # regex(...) fails if it cannot find a match
  validation {
    condition     = can(regex("ova$", var.base_ova_filename))
    error_message = "The base_ova_filename value must be a valid ova file, ending with \"*.ova\"."
  }
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
  ami_name = "${var.base_ova_filename}-${local.timestamp}"
}
source "virtualbox-ovf" "local" {
  format               = "ova"
  guest_additions_mode = "disable" # Must be one of: [disable attach upload]
  headless             = true
  keep_registered      = true
  output_directory     = "${path.cwd}/packer_output/${local.ami_name}"
  shutdown_command     = "sudo -S shutdown -P now"
  source_path          = "${path.cwd}/${var.base_ova_filename}"
  ssh_password         = "test"
  ssh_username         = "test"
}

build {
  sources = ["source.virtualbox-ovf.local"]

  provisioner "shell" {
    inline = [
    "sleep 10",
    "sudo apt install -y curl git python3-pip build-essential libssl-dev libffi-dev ansible"
    ]
  }

  provisioner "ansible-local" {
    galaxy_file = "../../ansible/requirements.yml"
    playbook_file           = "../../../../ansible/run_playbook.yaml"
    role_paths              = ["../../../../ansible/roles"]
    playbook_dir            = "../../../../ansible"
    clean_staging_directory = true
  }

  provisioner "shell" {
    inline = [
      "sudo mkdir -p /opt/cis-hardening",
      "cd /opt/cis-hardening",
      "sudo git clone https://github.com/ovh/debian-cis.git .",
      "sudo cp debian/default /etc/default/cis-hardening",
      "sudo mkdir -p /opt/lynis && cd /opt/lynis",
      "sudo  git clone https://github.com/CISOfy/lynis .",
      "sudo bash /opt/cis-hardening/bin/hardening.sh --audit-all --apply",
      "sudo debsecan --format detail",
      "sudo chown -R 0:0 /opt/lynis/",
      "sudo bash /opt/lynis/lynis audit system --reverse-colors --verbose"
    ]
  }
}
