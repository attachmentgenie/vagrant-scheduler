job "demo-web-app" {
  datacenters = ["services"]

  group "demo" {
    task "server" {

      vault {
        policies = ["access-tables"]
      }

      driver = "docker"
      config {
        image = "hashicorp/nomad-vault-demo:latest"
        port_map {
          http = 8080
        }

        volumes = [
          "secrets/config.json:/etc/demo/config.json"
        ]
      }

      template {
        data = <<EOF
{{ with secret "database/creds/accessdb" }}
  {
    "host": "database.service.consul",
    "port": 5432,
    "username": "{{ .Data.username }}",
    "password": {{ .Data.password | toJSON }},
    "db": "postgres"
  }
{{ end }}
EOF
        destination = "secrets/config.json"
      }

      resources {
        network {
          port "http" {}
        }
      }

      service {
        name = "nomad-vault-demo"
        port = "http"

        tags = [
          "urlprefix-/",
          "traefik.enable=true",
          "traefik.frontend.rule=Host:demo.traefik",
        ]

        check {
          type     = "tcp"
          interval = "2s"
          timeout  = "2s"
        }
      }
    }
  }
}