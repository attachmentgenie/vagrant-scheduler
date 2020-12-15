job "example" {
  datacenters = ["services"]
  type = "service"

  constraint {
    operator  = "distinct_hosts"
    value     = "true"
  }

  group "nginx" {
    count = 2

    network {
      port "http" {
        to = 80
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

    task "nginx" {
      driver = "docker"

      config {
        image = "nginx"
        ports = ["http"]
      }

      resources {
        cpu    = 100 # 100 MHz
        memory = 128 # 128 MB
      }
    }
  }
}