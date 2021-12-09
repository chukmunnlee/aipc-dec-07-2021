data digitalocean_ssh_key my-key {
    name = "mykey"
}

data digitalocean_image aipc-server {
    name = "aipc-server"
}

// Server - Nginx
resource digitalocean_droplet my-droplet {
    name = "my-droplet"
    image = data.digitalocean_image.aipc-server.id
    size = var.DO_size
    region = var.DO_region
    ssh_keys = [ data.digitalocean_ssh_key.my-key.fingerprint ]
}

resource local_file "at_ipv4" {
    filename = "@${digitalocean_droplet.my-droplet.ipv4_address}"
    content = "${data.digitalocean_ssh_key.my-key.fingerprint}\n"
    file_permission = "0644"
}

output ipv4 {
    value = digitalocean_droplet.my-droplet.ipv4_address
}

output my-key-fingerprint {
    value = data.digitalocean_ssh_key.my-key.fingerprint
}