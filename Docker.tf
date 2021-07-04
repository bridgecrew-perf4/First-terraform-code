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
resource "docker_container" "nginx-servers" {
   name = "nginx-server${format("%02d", count.index+1)}"
   image = "nginx:1.11-alpine"
   count = 2
   env = ["DATABASE_IP = docker_container.database-server.ip_address, DATABASE_DATA = docker_volume.database_data,DATA_BASE_USERNAME = user, DATABASE_PASS = ahmad@haidara "]
   volumes {
     container_path = "/usr/share/nginx/html/index.html"
     host_path = abspath("index${count.index}.html")
     read_only = true
     
  }
  
}
data "template_file" "haproxy_config" { # prepare a template for the config file
  template = "${file("${path.module}/haproxy.config")}"
  vars = {
    server0 = docker_container.nginx-servers[0].ip_address
    server1 = docker_container.nginx-servers[1].ip_address
  }
}
resource "local_file" "haproxy_config" { # Write the config file with IP addresses to haproxy.config.rendered
    content     = data.template_file.haproxy_config.rendered
    filename = "${path.module}/haproxy.config.rendered"
}
resource "docker_container" "haproxy"{
	image = "haproxy:1.5.18"
	name = "haproxy"
	restart = "always"
  ports {
    internal = 80
    external = 8080
  }
	volumes {
		container_path  = "/usr/local/etc/haproxy/haproxy.cfg"
		host_path = abspath("haproxy.config.rendered")
		read_only = false
	}
  depends_on = [
    local_file.haproxy_config # Wait until the config file is created
  ]
}
resource "docker_image" "mysql" {
  name = "mysql:latest"
}
resource "docker_container" "database"{
       name  = "database-server"
       image = "mysql:5.7"
       env = ["MYSQL_ROOT_PASSWORD=ahmad@haidara"]





       volumes {
               container_path   = "/var/lib/mysql/"
               host_path = abspath("mysql_database")
               volume_name = "database_data"
               read_only = false
               

       }
       

}


resource "docker_volume" "Database_data" {
  name = "Database_data"


}
