#  vagrant-scheduler

A vagrant setup that create container schedulers

## Requirements
    Virtualbox                  => https://www.virtualbox.org
    Vagrant                     => http://www.vagrantup.com
    vagrant-hostmanager         => vagrant plugin install vagrant-hostmanager
    vagrant-puppet-install      => vagrant plugin install vagrant-puppet-install
    vagrant-cachier  (optional) => vagrant plugin install vagrant-cachier
    
## Preparation

    git submodule update --init
    bundle install
    
## Setup

    vagrant up

## Inspec tests

    bundle exec rake
    bundle exec rake inspec[centos7] 

## TLDR

### (G)UI interfaces

    
    - name: puppetmaster, puppetserver
    - name: dns, BIND9 server.
    - name: nomad, consul, nomad and vault server
      nomad job:
        - example:
            type: docker
            image: nginx
            constraint: "distinct_hosts => true"
            count: 2
        - demo-db:
            type: docker
            image: hashicorp/postgres-nomad-demo:latest
        - demo-web:
            type: docker
            image: hashicorp/nomad-vault-demo:latest
            constraint: "distinct_hosts => true"
            count: 2
      public_vhosts:
        - http://nomad.scheduler.vagrant:8500
        - http://nomad.scheduler.vagrant:4646
        - http://nomad.scheduler.vagrant:8200
    - name: proxy, traefik
      public_vhosts:
        - http://proxy.scheduler.vagrant:8080
        - http://consul.traefik admin:secret
        - http://dashboard.traefik admin:secret
        - http://demo.traefik/names
        - http://example.traefik
        - http://nomad.traefik admin:secret
        - http://vault.traefik
    - name: node1, nomad client, consul client, docker
    - name: node2, nomad client, consul client, docker

## Ingress

    - consul UI, traefik frontend to consul dashboard backend (consul_catalog)
    - traefik UI, traefik frontend to traefik dashboard backend (consul_catalog)
    - demo, traefik frontend to demo nomad job backend (consul_catalog)
    - example, traefik frontend to example nomad job backend (consul_catalog)
    - nomad UI, traefik frontend to nomad dashboard backend (consul_catalog)
    - vault UI, traefik frontend to vault dashboard backend (consul_catalog)
        
## Jobs

### Example

The example job is automatically started during the provisioning of the nomad node. This shows that one can schedule jobs without the required constrains being in place or even without any clients online.
The job will patiently wait until nodes that meet the constrains become available. When node1 comes online 1 of the copies is already started there, while we build out node2. 

    curl http://example.traefik/

### Demo

The demo job automates the nomad vault integration example [1], and is a somewhat more elaborate job that requires a bit of manual orchestration.

intialize and unlock vault, single unlock setup is fine for this vagrant setup, please set up something more robust in prod.
copy the root token into terraform/vault.tf and production/hieradata/node/nomad.yaml, again this is fine for this vagrant setup, please set up something more robust in prod.

    export NOMAD_ADDR=http://nomad.scheduler.vagrant:4646
    nomad job run nomad/demo-db.nomad
    (cd terraform && terraform init && terraform plan && terraform apply -auto-approve)
    nomad job run nomad/demo-web.nomad
    curl http://demo.traefik/names

[1] https://www.nomadproject.io/guides/integrations/vault-integration/index.html
