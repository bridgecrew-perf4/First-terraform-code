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

resource "docker_image" "redis" {
	name = "redis:latest"
}

resource "docker_container" "redis-servers" {
	image = "${docker_image.redis.latest}"
	name = "redis-${format("%02d", count.index+1)}"

	count = 1

	restart = "always"

	volumes {
		container_path  = "/usr/local/etc/redis"
		host_path = "/home/dmportella/_workspaces/terraform/redis-cluster/config/redis"
		read_only = false
	}

	command = ["redis-server", "/usr/local/etc/redis/redis.conf"]
}

resource "docker_container" "haproxy-redis-lb" {
	depends_on = ["docker_container.redis-servers"]

	image = "haproxy:1.5.18"
	name = "haproxy-redis-lb"

	restart = "always"

	volumes {
		container_path  = "/usr/local/etc/haproxy"
		host_path = "/home/dmportella/_workspaces/terraform/redis-cluster/config/haproxy"
		read_only = false
	}
}

         
