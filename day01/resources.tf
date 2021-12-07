// docker pull stackupiss/dov-bear:v2
resource docker_image container-image {
    count = length(var.containers)
    name = var.containers[count.index].imageName
    keep_locally = var.containers[count.index].keepImage
}

resource docker_container container-app {
    count = length(var.containers)
    name = var.containers[count.index].containerName
    image = docker_image.container-image[count.index].latest
    ports {
        internal = var.containers[count.index].containerPort
        //external = var.containers[count.index].externalPort
    }
    env = var.containers[count.index].envVariables
}

output externalPorts {
    value = flatten(docker_container.container-app[*].ports[*].external)
    sensitive = true
}
/*
output port0 {
    value = docker_container.container-app[0].ports[0].external
}
output port1 {
    value = docker_container.container-app[1].ports[0].external
}
*/

// docker pull stackupiss/fortune:v2

// docker run -d -p 8080:3000 --name app0 stackupiss/dov-bear:v2
/*
resource docker_container dov-app {
    name = var.name
    image = docker_image.dov-bear.latest
    ports {
        internal = 3000
        external = 8080
    }
    env = [ "INSTANCE_NAME=dov-app", "INSTANCE_HASH=abc123" ]
}
*/