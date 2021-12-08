data digitalocean_ssh_key my-key {
    name = "my-key"
}

// Docker
data docker_image dov-image {
    name = var.app_image
}

resource docker_container dov-container {
    count = var.app_count
    name = "dov-${count.index}"
    image = data.docker_image.dov-image.id
    ports {
        internal = 3000
    }
    env = [ "INSTANCE_NAME=dov-${count.index}" ]
}

resource local_file nginx-conf {
    filename = "nginx.conf"
    file_permission = 0644
    content = templatefile("nginx.conf.tpl", {
        docker_host = var.docker_host
        ports = flatten(docker_container.dov-container[*].ports[*].external)
    })
}

// Server - Nginx
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
        private_key = var.private_key
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

    provisioner file {
        source = local_file.nginx-conf.filename
        destination = "/etc/nginx/nginx.conf"
    }

    provisioner remote-exec {
        inline = [
            "nginx -s reload"
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

// Cloudflare
data cloudflare_zone myzone {
    name = var.CF_zone
}

resource cloudflare_record a-dov {
    zone_id = data.cloudflare_zone.myzone.zone_id
    name = "dov"
    type = "A"
    value = digitalocean_droplet.my-droplet.ipv4_address
    proxied = true
}

output ipv4 {
    value = digitalocean_droplet.my-droplet.ipv4_address
}

output my-key-fingerprint {
    value = data.digitalocean_ssh_key.my-key.fingerprint
}

output app-ports {
    value = flatten(docker_container.dov-container[*].ports[*].external)
}