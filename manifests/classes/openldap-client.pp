# File::      <tt>openldap-client.pp</tt>
# Author::    Hyacinthe Cartiaux (hyacinthe.cartiaux@uni.lu)
# Copyright:: Copyright (c) 2011 Hyacinthe Cartiaux
# License::   GPLv3
#
# ------------------------------------------------------------------------------
# = Class: openldap::client
#
# Configure and manage openldap client
#
# == Parameters:
#
# $ensure:: *Default*: 'present'. Ensure the presence (or absence) of openldap
#
# $base:: *Default*: 'dc=uni,dc=lu'. Base (dn of the rootDSE) of the directory
#
# $uri:: *Default*: 'ldap://localhost'. URI of the ldap server
#
# $use_ssl:: *Default*: 'no'. Ensure the usage of SSL
#
# == Actions:
#
# Install and configure openldap client tools
#
# == Requires:
#
# n/a
#
# == Sample Usage:
#
#     import openldap::client
#
# You can then specialize the various aspects of the configuration,
# for instance:
#
#         class { 'openldap::client':
#             ensure  => 'present',
#             base    => 'dc=uni,dc=lu',
#             uri     => 'ldap://localhost:389',
#             use_ssl => 'yes'
#         }
#
# == Warnings
#
# /!\ Always respect the style guide available
# here[http://docs.puppetlabs.com/guides/style_guide]
#
#
# [Remember: No empty lines between comments and class definition]
#
class openldap::client ( 
        $ensure  = $openldap::params::ensure,
        $base    = $openldap::params::suffix,
        $uri     = $openldap::params::uri,
        $use_ssl = $openldap::params::ssl
        ) inherits openldap::params
{
    info ("Configuring openldap (with ensure = ${ensure})")

    if ! ("${ensure}" in [ 'present', 'absent' ]) {
        fail("openldap 'ensure' parameter must be set to either 'absent' or 'present'")
    }

    case $::operatingsystem {
         debian, ubuntu:         { include openldap::client::debian }
#        redhat, fedora, centos: { include openldap::client::redhat }
        default: {
            fail("Module $module_name is not supported on $operatingsystem")
        }
    }
}

# ------------------------------------------------------------------------------
# = Class: openldap::client::common
#
# Base class to be inherited by the other openldap classes
#
# Note: respect the Naming standard provided here[http://projects.puppetlabs.com/projects/puppet/wiki/Module_Standards]
class openldap::client::common {

    # Load the variables used in this module. Check the openldap-params.pp file
    require openldap::params

    package { "${openldap::params::packagename_client}":
        name    => "${openldap::params::packagename_client}",
        ensure  => "${openldap::client::ensure}",
    }

    file { 'ldap.conf':
        path    => "${openldap::params::configfile_client}",
        owner   => "${openldap::params::configfile_owner}",
        group   => "${openldap::params::configfile_group}",
        mode    => "${openldap::params::configfile_client_mode}",
        ensure  => "${openldap::client::ensure}",
        content => template("openldap/ldap.conf.erb"),
        require => Package["${openldap::params::packagename_client}"],
    }

}


# ------------------------------------------------------------------------------
# = Class: openldap::client::debian
#
# Specialization class for Debian systems
class openldap::client::debian inherits openldap::client::common { }

# ------------------------------------------------------------------------------
# = Class: openldap::client::redhat
#
# Specialization class for Redhat systems
class openldap::client::redhat inherits openldap::client::common { }



