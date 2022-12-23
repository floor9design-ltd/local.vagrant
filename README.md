# local.vagrant

[![Latest Version](https://img.shields.io/github/v/release/floor9design-ltd/local.vagrant?include_prereleases&style=plastic)](https://github.com/floor9design-ltd/local.vagrant/releases)
[![Software License](https://img.shields.io/badge/license-MIT-brightgreen.svg?style=plastic)](LICENCE.md)

## Introduction

This repository offers a Vagrant box with bootstrap scripts that allow for very easy and automated configuration of 
setup.

## Features

The system is preconfiured to set up all dependencies for:

* php
* mysql
* node
* .. etc

These are configured with addons ready for major frameworks such as:

* laravel
* cakephp
* wordpress

It allows quick and programmatic setup of:

* shared folders
* apache domains
* database integration

Includes DB drivers for:

* mysql 
* sql server

## Requirements

This is a Vagrant setup, so of course... Vagrant.

## Install

* Download/clone the repo.
* To make this useful, follow the instructions in the Configuration section
* Run `vagrant up` (also see the Usage section)

## Usage

As this is a Vagrant box, you should refer to the [Vagrant docs](https://developer.hashicorp.com/vagrant/docs) as they 
have plenty of info.

However, as an overview:

* navigate to your folder
* run `vagrant up`

If you are a phpstorm user, then it is very useful to set this up: 

* `settings` / `tools` / `vagrant` 

Note this can be set up for a folder outside your current project.

## Configuration

Out of the box, this vagrant box is essentially empty. It spins up an Ubuntu server with all the standard items you 
would expect on a production server for most modern php frameworks.

Without configuration, there will be no shared folders, databases/database users or apache configs.

In order to configure this, the bootstrap attempts to load config files by parsing over three folders:

* `/synced-folders/`
* `/sites-available/`
* `/database/`

### `/synced-folders/`

As explained in the Vagrant documentation, A synced folder maps a local location onto the VM. Ideally this is your 
codebase. To add your own vagrant locations: 

To enable:
* copy the example file `development.local.rb.example` and rename it to something appropriate. Eg: `mysite.local.rb`
* modify the contents of the file to map appropriately

Note the following:

* it is likely a good idea to use a relative reference for local folders eg: `../mysitefolder/`. This makes sharing the 
file useful to share within organisations 
* if these are to be used as apache/website folders, it is a standard practice to map the usual file format, for 
example: `/var/www/mysite`

### `/sites-available/`

If you wish to serve a folder through apache, these can be enabled using the `/sites-available/` folder.

The process:
* The contents of `/sites-available/` are standard apache `conf` files. 
* These files are copied to the server at `/etc/sites-available/`. 
* These are then parsed, with domains and enabled
* These domains are parsed and added to the server hosts files

To enable:
* copy the example file `development.local.conf.example` and rename it to something appropriate. Eg: `mysite.local.conf`
* update the `<Directory "/var/www/development.local">` and `DocumentRoot` lines with a mapped directory set up in 
`/synced-folders/`
* update the `ErrorLog` and `CustomLog` to appropriate values, for example: `/var/log/mysite.local/error.log`, 
`/var/log/mysite.local/access.log`
* update the `ServerName` and `ServerAlias` to appropriate values, for example: `mysite.local`
* optionally, update the `ServerAdmin` email

Note that the parsing is not particularly complex, so try not to modify the base file too much.

### `/database/`

The `/database/` contains bash scripts that set up databases with standard permissions. This can be extended with 
as much code is required, for example seeders etc. 

To enable:
* update `mysql_application_database`, `mysql_application_username`, `mysql_application_password` with appropriate 
values

## Credits

- [Rick](https://github.com/elb98rm)

## Changelog

A changelog is generated here:

* [Change log](CHANGELOG.md)

## License

MIT