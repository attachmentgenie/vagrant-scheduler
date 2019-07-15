job "demo-web" {
  datacenters = ["services"]

  group "demo" {
    count = 2

    constraint {
      operator  = "distinct_hosts"
      value     = "true"
    }

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
    "port": 25432,
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
        name = "demo-web"
        port = "http"

        tags = [
          "urlprefix-/",
          "traefik.enable=true",
          "traefik.frontend.rule=Host:demo.traefik"
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