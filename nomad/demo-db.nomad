job "demo-db" {
  datacenters = ["services"]
  type = "service"

  group "db" {

    network {
      mode = "bridge"
      port  "db"{
        to = 5432
      }
    }

    service {
      name = "demo-db"
      port = "db"

      connect {
        sidecar_service {}
      }
    }

    task "server" {
      driver = "docker"

      config {
        image = "hashicorp/postgres-nomad-demo:latest"
        ports = ["db"]
      }
    }
  }
}