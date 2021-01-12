job "demo-web" {
  datacenters = ["services"]
  type = "service"

  constraint {
    operator  = "distinct_hosts"
    value     = "true"
  }

  group "demo" {
    count = 2

    network {
      mode = "bridge"
      port "http" {
        to = 8080
      }
    }

    service {
      name = "demo-web"
      port = "http"

      tags = [
        "urlprefix-/",
        "traefik.enable=true",
        "traefik.http.routers.demo-web.rule=Host(`demo.traefik`)"
      ]

      connect {
        sidecar_service {
          tags = ["sidecar"]
          proxy {
            upstreams {
              destination_name = "demo-db"
              local_bind_port = 5432
            }
          }
        }
      }
    }

    task "server" {

      vault {
        policies = ["access-tables"]
      }

      driver = "docker"
      config {
        image = "hashicorp/nomad-vault-demo:latest"
        ports = ["http"]
        volumes = [
          "secrets/config.json:/etc/demo/config.json"
        ]
      }

      template {
        data = <<EOF
{{ with secret "database/creds/accessdb" }}
  {
    "host": "localhost",
    "port": 5432,
    "username": "{{ .Data.username }}",
    "password": {{ .Data.password | toJSON }},
    "db": "postgres"
  }
{{ end }}
EOF
        destination = "secrets/config.json"
      }
    }
  }
}