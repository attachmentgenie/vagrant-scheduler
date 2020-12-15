job "demo-db" {
  datacenters = ["services"]

  group "db" {

    network {
      port  "db"{
        static = 25432
        to = 5432
      }
    }

    service {
      name = "database"
      port = "db"

      check {
        type     = "tcp"
        interval = "2s"
        timeout  = "2s"
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