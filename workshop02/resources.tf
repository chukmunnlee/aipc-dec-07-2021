data digitalocean_ssh_key mykey {
    name = "mykey"
}

resource digitalocean_droplet myserver {
    name = "myserver"
    image = var.DO_image
    size = var.DO_size
    region = var.DO_region

    ssh_keys = [ data.digitalocean_ssh_key.mykey.fingerprint ]
}

resource local_file inventory-yaml {
    filename = "setup/inventory.yaml"
    file_permission = 0644
    content = templatefile("inventory.yaml.tpl", {
        host_name = digitalocean_droplet.myserver.name
        host_ip = digitalocean_droplet.myserver.ipv4_address
        private_key = "../${var.private_key}"
        public_key = "../${var.public_key}"
    })
}

output myserver-ipv4 {
    value = digitalocean_droplet.myserver.ipv4_address
}