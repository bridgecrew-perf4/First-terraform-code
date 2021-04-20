terraform {
   required_providers {
   nomad = {
   source = "hashicorp/nomad"
   version = "1.4.14"
           }
   docker = {
     source = "kreuzwerker/docker"
     version = "2.11.0"
    }
  }
}

provider "docker" {
 
}

resource "docker_image" "nginx" {
       name = "nginx:1.11-alpine"
}

resource "docker_container" "nginx-server" {
   name = "nginx-server"
   image = "${docker_image.nginx.latest}"
   ports {
   internal = 80
    }
   volumes {
     container_path = "/usr/share/nginx/html"
     host_path = "/home/scrapbook/totorial/www"
     read_only = true
  }
}

resource "docker_container" "nginx-server2" {
   name = "nginx-server2"
   image = "${docker_image.nginx.latest}"
   ports {
   internal = 80
    }
   volumes {
     container_path = "/usr/share/nginx/html"
     host_path = "/home/Dock"
     read_only = true
  }
}

resource "docker_image" "nomad" {
       name = "redis:3.2"
}



resource "docker_container" "haproxy_load_balancer" {
   name = "haproxy_load_balancer"
   image = "${docker_image.nomad.latest}"
   }



