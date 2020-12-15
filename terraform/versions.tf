terraform {
  required_providers {
    consul = {
      source = "hashicorp/consul"
    }
    vault = {
      source = "hashicorp/vault"
    }
  }
  required_version = ">= 0.13"
}
