// docker pull stackupiss/dov-bear:v2
resource docker_image dov-bear {
    name = "stackupiss/dov-bear:v2"
    keep_locally = true
}

// docker pull stackupiss/fortune:v2

// docker run -d -p 8080:3000 --name app0 stackupiss/dov-bear:v2
resource docker_container dov-app {
    name = "app0"
    image = docker_image.dov-bear.latest
    ports {
        internal = 3000
        external = 8080
    }
    env = [ "INSTANCE_NAME=dov-app", "INSTANCE_HASH=abc123" ]
}

// deploy the fortune