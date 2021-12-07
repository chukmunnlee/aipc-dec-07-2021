terraform {
    required_version = ">1.0.0"
    required_providers {
        digitalocean = {
          source = "digitalocean/digitalocean"
          version = "~> 2.0"
        }
        local = {
            source = "hashicorp/local"
            version = "2.1.0"
        }
  }
}

provider "digitalocean" {
    token = var.DO_token
}