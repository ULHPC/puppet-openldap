-*- mode: markdown; mode: visual-line;  -*-

# Openldap Puppet Module 

[![Puppet Forge](http://img.shields.io/puppetforge/v/ULHPC/openldap.svg)](https://forge.puppetlabs.com/ULHPC/openldap)
[![License](http://img.shields.io/:license-GPL3.0-blue.svg)](LICENSE)
![Supported Platforms](http://img.shields.io/badge/platform-debian-lightgrey.svg)
[![Documentation Status](https://readthedocs.org/projects/ulhpc-puppet-openldap/badge/?version=latest)](https://readthedocs.org/projects/ulhpc-puppet-openldap/?badge=latest)

Configure and manage openldap

      Copyright (c) 2018 UL HPC Team <hpc-sysadmins@uni.lu>
      

| [Project Page](https://github.com/ULHPC/puppet-openldap) | [Sources](https://github.com/ULHPC/puppet-openldap) | [Documentation](https://ulhpc-puppet-openldap.readthedocs.org/en/latest/) | [Issues](https://github.com/ULHPC/puppet-openldap/issues) |

## Synopsis

Configure and manage openldap.

This module implements the following elements: 

* __Puppet classes__:
    - `openldap` 
    - `openldap::client` 
    - `openldap::client::common` 
    - `openldap::client::common::debian` 
    - `openldap::client::common::redhat` 
    - `openldap::params` 
    - `openldap::server` 
    - `openldap::server::common` 
    - `openldap::server::common::debian` 

* __Puppet definitions__: 
    - `openldap::server::acl` 
    - `openldap::server::admin::entry` 
    - `openldap::server::alias::entry` 
    - `openldap::server::database` 
    - `openldap::server::ou::entry` 
    - `openldap::server::root::entry` 
    - `openldap::server::slapadd` 
    - `openldap::server::sync::consumer` 

All these components are configured through a set of variables you will find in
[`manifests/params.pp`](manifests/params.pp). 

_Note_: the various operations that can be conducted from this repository are piloted from a [`Rakefile`](https://github.com/ruby/rake) and assumes you have a running [Ruby](https://www.ruby-lang.org/en/) installation.
See `docs/contributing.md` for more details on the steps you shall follow to have this `Rakefile` working properly. 

## Dependencies

See [`metadata.json`](metadata.json). In particular, this module depends on 

* [puppetlabs/stdlib](https://forge.puppetlabs.com/puppetlabs/stdlib)
* [puppetlabs/concat](https://forge.puppetlabs.com/puppetlabs/concat)
* [ULHPC/openssl](https://forge.puppetlabs.com/ULHPC/openssl)

## Overview and Usage

### Class `openldap`

This is the main class defined in this module.
It accepts the following parameters: 

* `$ensure`: default to 'present', can be 'absent'

Use it as follows:

     include ' openldap'

See also [`tests/init.pp`](tests/init.pp)

### Class `openldap::client`

See [`tests/client.pp`](tests/client.pp)
### Class `openldap::server`

See [`tests/server.pp`](tests/server.pp)

### Definition `openldap::server::acl`

The definition `openldap::server::acl` provides ...
This definition accepts the following parameters:

* `$ensure`: default to 'present', can be 'absent'
* `$content`: specify the contents of the directive as a string
* `$source`: copy a file as the content of the directive.

Example:

        openldap::server::acl { 'toto':
		      ensure => 'present',
        }

See also [`tests/server/acl.pp`](tests/server/acl.pp)

### Definition `openldap::server::admin::entry`

The definition `openldap::server::admin::entry` provides ...
This definition accepts the following parameters:

* `$ensure`: default to 'present', can be 'absent'
* `$content`: specify the contents of the directive as a string
* `$source`: copy a file as the content of the directive.

Example:

        openldap::server::admin::entry { 'toto':
		      ensure => 'present',
        }

See also [`tests/server/admin/entry.pp`](tests/server/admin/entry.pp)

### Definition `openldap::server::alias::entry`

The definition `openldap::server::alias::entry` provides ...
This definition accepts the following parameters:

* `$ensure`: default to 'present', can be 'absent'
* `$content`: specify the contents of the directive as a string
* `$source`: copy a file as the content of the directive.

Example:

        openldap::server::alias::entry { 'toto':
		      ensure => 'present',
        }

See also [`tests/server/alias/entry.pp`](tests/server/alias/entry.pp)

### Definition `openldap::server::database`

The definition `openldap::server::database` provides ...
This definition accepts the following parameters:

* `$ensure`: default to 'present', can be 'absent'
* `$content`: specify the contents of the directive as a string
* `$source`: copy a file as the content of the directive.

Example:

        openldap::server::database { 'toto':
		      ensure => 'present',
        }

See also [`tests/server/database.pp`](tests/server/database.pp)

### Definition `openldap::server::ou::entry`

The definition `openldap::server::ou::entry` provides ...
This definition accepts the following parameters:

* `$ensure`: default to 'present', can be 'absent'
* `$content`: specify the contents of the directive as a string
* `$source`: copy a file as the content of the directive.

Example:

        openldap::server::ou::entry { 'toto':
		      ensure => 'present',
        }

See also [`tests/server/ou/entry.pp`](tests/server/ou/entry.pp)

### Definition `openldap::server::root::entry`

The definition `openldap::server::root::entry` provides ...
This definition accepts the following parameters:

* `$ensure`: default to 'present', can be 'absent'
* `$content`: specify the contents of the directive as a string
* `$source`: copy a file as the content of the directive.

Example:

        openldap::server::root::entry { 'toto':
		      ensure => 'present',
        }

See also [`tests/server/root/entry.pp`](tests/server/root/entry.pp)

### Definition `openldap::server::slapadd`

The definition `openldap::server::slapadd` provides ...
This definition accepts the following parameters:

* `$ensure`: default to 'present', can be 'absent'
* `$content`: specify the contents of the directive as a string
* `$source`: copy a file as the content of the directive.

Example:

        openldap::server::slapadd { 'toto':
		      ensure => 'present',
        }

See also [`tests/server/slapadd.pp`](tests/server/slapadd.pp)

### Definition `openldap::server::sync::consumer`

The definition `openldap::server::sync::consumer` provides ...
This definition accepts the following parameters:

* `$ensure`: default to 'present', can be 'absent'
* `$content`: specify the contents of the directive as a string
* `$source`: copy a file as the content of the directive.

Example:

        openldap::server::sync::consumer { 'toto':
		      ensure => 'present',
        }

See also [`tests/server/sync/consumer.pp`](tests/server/sync/consumer.pp)


## Librarian-Puppet / R10K Setup

You can of course configure the openldap module in your `Puppetfile` to make it available with [Librarian puppet](http://librarian-puppet.com/) or
[r10k](https://github.com/adrienthebo/r10k) by adding the following entry:

     # Modules from the Puppet Forge
     mod "ULHPC/openldap"

or, if you prefer to work on the git version: 

     mod "ULHPC/openldap", 
         :git => 'https://github.com/ULHPC/puppet-openldap',
         :ref => 'production' 

## Issues / Feature request

You can submit bug / issues / feature request using the [ULHPC/openldap Puppet Module Tracker](https://github.com/ULHPC/puppet-openldap/issues). 

## Developments / Contributing to the code 

If you want to contribute to the code, you shall be aware of the way this module is organized. 
These elements are detailed on [`docs/contributing.md`](contributing/index.md).

You are more than welcome to contribute to its development by [sending a pull request](https://help.github.com/articles/using-pull-requests). 

## Puppet modules tests within a Vagrant box

The best way to test this module in a non-intrusive way is to rely on [Vagrant](http://www.vagrantup.com/).
The `Vagrantfile` at the root of the repository pilot the provisioning various vagrant boxes available on [Vagrant cloud](https://atlas.hashicorp.com/boxes/search?utf8=%E2%9C%93&sort=&provider=virtualbox&q=svarrette) you can use to test this module.

See [`docs/vagrant.md`](vagrant.md) for more details. 

## Online Documentation

[Read the Docs](https://readthedocs.org/) aka RTFD hosts documentation for the open source community and the [ULHPC/openldap](https://github.com/ULHPC/puppet-openldap) puppet module has its documentation (see the `docs/` directly) hosted on [readthedocs](http://ulhpc-puppet-openldap.rtfd.org).

See [`docs/rtfd.md`](rtfd.md) for more details.

## Licence

This project and the sources proposed within this repository are released under the terms of the [GPL-3.0](LICENCE) licence.


[![Licence](https://www.gnu.org/graphics/gplv3-88x31.png)](LICENSE)
