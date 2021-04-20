terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "2.11.0"
    }
  }
}

provider "docker" {
}


resource "docker_image" "nginx" {
   name     = "nginx:1.11-alpine"
   keep_locally = true 
}

resource "docker_container" "nginx-server" {
   name     = "nginx-server"
   image    = docker_image.nginx.latest

ports {
internal = 80
}

volumes {
  container_path = "/usr/share/nginx/html/"
  host_path      = "/data/"
  read_only      = true 
}
}
 
