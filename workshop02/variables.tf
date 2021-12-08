variable DO_token {
    type = string
    sensitive = true
}

variable DO_image {
    type = string
    default = "ubuntu-20-04-x64"
}

variable DO_size {
    type = string
    default = "s-1vcpu-1gb"
}

variable DO_region {
    type = string
    default = "sgp1"
}

variable CF_email {
    type = string
}

variable CF_api_token {
    type = string
    sensitive = true
}

variable CF_zone {
    type = string
}

variable private_key {
    type = string
}
variable public_key {
    type = string
}