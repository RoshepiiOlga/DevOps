build {
    sources = [
        "source.amazon-ebs.aws-ubuntu",
        "source.lxd.ubuntu"
    ]

    provisioner "shell" {
        script = "scripts/prom-init.sh"
    }

    provisioner "file" {
        source = "prometheus.service"
        destination = "/tmp/"
    }

    provisioner "shell" {
        script = "scripts/prom-post.sh"
    }
}
