terraform {
   required_providers {
   
   docker = {
     source = "kreuzwerker/docker"
     version = "2.9.0"
    }
  }
}

provider "docker" {
 
}

resource "docker_image" "nginx" {
       name = "nginx:1.11-alpine"
}

resource "docker_container" "nginx-servers" {
   name = "nginx-server${format("%02d", count.index+1)}"
   image = "${docker_image.nginx.latest}"
   count = 2
   ports {
   internal = 80
    }
   volumes {
     container_path = "/home/terraform/Desktop/Terraform/nginx-container/html"
     host_path = "/home/terraform/Desktop/Terraform/nginx-servers"
     read_only = true
  }
}


resource "docker_image" "redis" {
	name = "redis:latest"
}



resource "docker_container" "haproxy"{

	image = "haproxy:1.5.18"
	name = "haproxy"
	restart = "always"
	volumes {
		container_path  = "/home/terraform/Desktop/Terraform/haproxy-container"
		host_path = "/home/terraform/Desktop/Terraform/haproxy"
		read_only = false
	}
}

         
