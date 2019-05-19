#  vagrant-example

vagrant starter kit 

## Requirements
    Virtualbox                        => https://www.virtualbox.org
    Vagrant                           => http://www.vagrantup.com
    vagrant-hostmanager               => vagrant plugin install vagrant-hostmanager
    vagrant-cachier  (optional)       => vagrant plugin install vagrant-cachier
    vagrant-puppet-install (optional) => vagrant plugin install vagrant-puppet-install
    vagrant-triggers (optional)       => vagrant plugin install vagrant-triggers
    
## Preparation
    git submodule update --init
    
## Setup
    vagrant up

## TLDR
    
    - name: puppetmaster, puppetserver
    - name: nomad, nomad and consul server
      nomad job:
        - example:
            type: docker
            image: nginx
            constraint: "distinct_hosts => true"
            count: 2
      public_vhosts:
        - consul.scheduler.vagrant:8500, consul dashboard
        - nomad.scheduler.vagrant:4646, nomad dashboard
    - name: proxy, traefik
      public_vhosts:
        - proxy.website.vagrant:8080, traefik dashboard
        - consul.traefik, traefik frontend to consul dashboard backend (consul_catalog)
        - dashboard.traefik, traefik frontend to traefik dashboard backend (consul_catalog)
        - example.traefik, traefik fronted to example nomad job backend (consul_catalog)
        - nomad.traefik, traefik frontend to nomad dashboard backend (consul_catalog)
    - name: node1, nomad client, consul client, docker
    - name: node2, nomad client, consul client, docker

