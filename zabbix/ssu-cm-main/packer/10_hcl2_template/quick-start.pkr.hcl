# variable "access_key" {
#   type    = string
#   default = "${env("AWS_ACCESS_KEY_ID")}"
# }
# variable "profile" {
#   type = string
#   default = "${env("AWS_PROFILE")}"
# }

# variable "secret_key" {
#   type    = string
#   default = "${env("AWS_SECRET_ACCESS_KEY")}"
# }

locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

source "amazon-ebs" "quick-start" {
  # access_key    = "${var.access_key}"
  # secret_key    = "${var.secret_key}"
  # profile       = "${var.profile}"
  ami_name      = "packer-example ${local.timestamp}"
  instance_type = "t2.micro"
  region        = "us-east-1"
  source_ami    = "ami-af22d9b9"
  ssh_username  = "ubuntu"
}

build {
  sources = ["source.amazon-ebs.quick-start"]
}
