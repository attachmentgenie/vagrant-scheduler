job "demo-db" {
  datacenters = ["services"]
  type = "service"

  group "db" {

    network {
      port  "db"{
        static = 25432
        to = 5432
      }
    }

    service {
      name = "demo-db"
      port = "db"
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