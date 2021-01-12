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
      mode = "bridge"
      port "http" {
        to = 80
      }
    }

    service {
      name = "example"
      tags = [
        "traefik.enable=true",
        "traefik.http.routers.example.rule=Host(`example.traefik`)"
      ]
      port = "http"

      connect {
        sidecar_service {
          tags = ["sidecar"]
        }
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