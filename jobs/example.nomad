job "example" {
  datacenters = ["services"]
  type = "service"

  group "nginx" {
    count = 2

    constraint {
      operator  = "distinct_hosts"
      value     = "true"
    }

    task "nginx" {
      driver = "docker"

      config {
        image = "nginx"
        port_map {
          http = 80
        }
      }

      resources {
        cpu    = 100 # 100 MHz
        memory = 128 # 128 MB
        network {
          mbits = 10
          port "http" {}
        }
      }

      service {
        name = "example"
        tags = ["traefik.enable=true"]
        port = "http"
        check {
          type     = "tcp"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}