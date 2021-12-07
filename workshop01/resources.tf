data digitalocean_ssh_key my-key {
    name = "my-key"
}

//loading from local
//resource digitalocean_ssh_key local-key {
//    name = "my-local-key"
//    public_key = file("/home/fred/tmp/mykey")
//}

resource digitalocean_droplet my-droplet {
    name = "my-droplet"
    image = var.DO_image
    size = var.DO_size
    region = var.DO_region
    ssh_keys = [ data.digitalocean_ssh_key.my-key.fingerprint ]

    // provisioner connection object
    connection {
        type = "ssh"
        user = "root"
        private_key = file("../../tmp/mykey")
        host = self.ipv4_address
    }

    provisioner remote-exec {
        inline = [
            "apt update -y",
            "apt upgrade -y",
            "apt install nginx -y",
            "systemctl enable nginx",
            "systemctl start nginx",
        ]
    }
}

resource local_file "at_ipv4" {
    filename = "@${digitalocean_droplet.my-droplet.ipv4_address}"
    content = "${data.digitalocean_ssh_key.my-key.fingerprint}\n"
    file_permission = "0644"
}

resource local_file droplet_info {
    filename = "info.txt"
    content = templatefile("info.txt.tpl", {
        ipv4 = digitalocean_droplet.my-droplet.ipv4_address
        fingerprint = data.digitalocean_ssh_key.my-key.fingerprint
    })
    file_permission = "0644"
}

output ipv4 {
    value = digitalocean_droplet.my-droplet.ipv4_address
}

output my-key-fingerprint {
    value = data.digitalocean_ssh_key.my-key.fingerprint
}