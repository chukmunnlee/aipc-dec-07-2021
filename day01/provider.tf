terraform {
    // terraform version
    required_version = ">1.0.0"
    // one or more providers
    required_providers {
        docker = {
            source  = "kreuzwerker/docker"
            version = "2.15.0"
        }
        local = {
            source = "hashicorp/local"
            version = "2.1.0"
        }
    }
}

// configure the provider - specific to the provider
provider "docker" {
    host = "unix:///var/run/docker.sock"
}

provider "local" { }