# XIVAPI: Vagrant

This is a simple stack that runs XIVAPI v3 + Mogboard via Vagrant.

## Requirements

- Install vagrant: https://www.vagrantup.com/
- Install vagrant host manager plugin: https://github.com/devopsgroup-io/vagrant-hostmanager

## Getting setup

Make a folder where all XIVAPI projects (including Mogboard) can sit:

- `mkdir xivapi`
- `cd xivapi`

Clone XIVAPI (or Mogboard) and Vagrant

- `git clone https://github.com/xivapi/xivapi.com-v3.git`
- `git clone https://github.com/xivapi/xivapi.com-vagrant.git`

Build the vagrant and run it

- `cd xivapi.com-vagrant`
- `vagrant up`
