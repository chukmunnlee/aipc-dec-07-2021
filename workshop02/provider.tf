terraform {
    required_version = ">1.0.0"
    required_providers {
        digitalocean = {
          source = "digitalocean/digitalocean"
          version = "2.16.0"
        }
        cloudflare = {
          source = "cloudflare/cloudflare"
          version = "3.4.0"
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

provider "cloudflare" {
  email = var.CF_email
  api_token = var.CF_api_token
}