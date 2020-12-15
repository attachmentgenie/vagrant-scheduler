# Vault <-> Nomad integration as descibed on https://www.nomadproject.io/guides/integrations/vault-integration/index.html
resource "vault_policy" "nomad-server" {
  name = "nomad-server"

  policy = <<EOT
# Allow creating tokens under "nomad-cluster" role. The role name should be
# updated if "nomad-cluster" is not used.
path "auth/token/create/nomad-cluster" {
  capabilities = ["update"]
}

# Allow looking up "nomad-cluster" role. The role name should be updated if
# "nomad-cluster" is not used.
path "auth/token/roles/nomad-cluster" {
  capabilities = ["read"]
}

# Allow looking up the token passed to Nomad to validate the token has the
# proper capabilities. This is provided by the "default" policy.
path "auth/token/lookup-self" {
  capabilities = ["read"]
}

# Allow looking up incoming tokens to validate they have permissions to access
# the tokens they are requesting. This is only required if
# `allow_unauthenticated` is set to false.
path "auth/token/lookup" {
  capabilities = ["update"]
}

# Allow revoking tokens that should no longer exist. This allows revoking
# tokens for dead tasks.
path "auth/token/revoke-accessor" {
  capabilities = ["update"]
}

# Allow checking the capabilities of our own token. This is used to validate the
# token upon startup.
path "sys/capabilities-self" {
  capabilities = ["update"]
}

# Allow our own token to be renewed.
path "auth/token/renew-self" {
  capabilities = ["update"]
}
EOT
}

resource "vault_token_auth_backend_role" "nomad-cluster" {
  allowed_policies       = ["access-tables"]
  role_name              = "nomad-cluster"
  orphan                 = true
  token_explicit_max_ttl = "0"
  token_period           = "259200"
  renewable              = true
}

resource "vault_mount" "database" {
  path = "database"
  type = "database"
}

resource "vault_database_secret_backend_connection" "postgresql" {
  backend       = vault_mount.database.path
  name          = "postgresql"
  allowed_roles = ["accessdb"]

  postgresql {
    connection_url = "postgresql://postgres:postgres123@database.service.consul:25432/postgres?sslmode=disable"
  }
}

resource "vault_database_secret_backend_role" "accessdb" {
  backend = vault_mount.database.path
  name    = "accessdb"
  db_name = "postgresql"
  creation_statements = [
    "CREATE USER \"{{name}}\" WITH ENCRYPTED PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';",
    "GRANT USAGE ON ALL SEQUENCES IN SCHEMA public TO \"{{name}}\";",
    "GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO \"{{name}}\";",
    "GRANT ALL ON SCHEMA public TO \"{{name}}\";"
  ]
}

resource "vault_policy" "access-tables" {
  name = "access-tables"

  policy = <<EOT
path "database/creds/accessdb" {
  capabilities = ["read"]
}
EOT
}