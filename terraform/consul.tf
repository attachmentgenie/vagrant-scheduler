provider "consul" {
  address    = "nomad.scheduler.vagrant:8500"
  datacenter = "services"
}