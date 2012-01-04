# File::      <tt>openldap-server.pp</tt>
# Author::    Hyacinthe Cartiaux (hyacinthe.cartiaux@uni.lu)
# Copyright:: Copyright (c) 2011 Hyacinthe Cartiaux
# License::   GPLv3
#
# ------------------------------------------------------------------------------
# = Class: openldap::server
#
# Configure and manage openldap servers
#
# == Parameters:
#
# $ensure:: *Default*: 'present'. Ensure the presence (or absence) of openldap server
#
# $use_ssl:: *Default*: 'no'. Generate self signed certificates and use it
#
# $db_name:: *Default*: 'uni.lu'. Name of the database, used in configuration file
#
# $suffix:: *Default*: 'dc=uni,dc=lu'. suffix of the rootDSE
#
# admin_dn:: *Default*: 'cn=admin,dc=uni,dc=lu', dn of the admin entry of the database
#
# admin_pwd:: password of the administrator
#
# syncprov:: *Default*: 'no', if set to 'yes', the openldap server will be master for replication
#
# == Actions:
#
# Install and configure openldap
#
# == Requires:
#
# n/a
#
# == Sample Usage:
#
#     import openldap::server
#
# You can then specialize the various aspects of the configuration,
# for instance:
#
#     class { "openldap::server":
#         use_ssl   => 'yes',
#         db_name   => 'uni.lu',
#         suffix    => 'dc=uni,dc=lu',
#         admin_dn  => 'cn=admin,dc=uni,dc=lu',
#         admin_pwd => '********************',
#         syncprov  => 'yes',
#     }   
#
# == Warnings
#
# /!\ Always respect the style guide available
# here[http://docs.puppetlabs.com/guides/style_guide]
#
#
# [Remember: No empty lines between comments and class definition]
#
class openldap::server(
    $ensure    = $openldap::params::ensure,
    $use_ssl   = $openldap::params::ssl,
    $db_name   = $openldap::params::db_name,
    $suffix    = $openldap::params::suffix,
    $admin_dn  = $openldap::params::admin_dn,
    $admin_pwd = $openldap::params::admin_pwd,
    $syncprov  = $openldap::params::syncprov
    ) inherits openldap::params
{
    info ("Configuring openldap::server (with ensure = ${ensure})")

    if ! ($ensure in [ 'present', 'absent' ]) {
        fail("openldap 'ensure' parameter must be set to either 'absent' or 'present'")
    }

    case $::operatingsystem {
        debian, ubuntu:         { include openldap::server::debian }
#       redhat, fedora, centos: { include openldap::server::redhat }
        default: {
            fail("Module $module_name is not supported on $operatingsystem")
        }
    }
}

# ------------------------------------------------------------------------------
# = Class: openldap::server::common
#
# Base class to be inherited by the other openldap::server classes
#
# Note: respect the Naming standard provided here[http://projects.puppetlabs.com/projects/puppet/wiki/Module_Standards]
class openldap::server::common {

    # Load the variables used in this module. Check the openldap-params.pp file
    require openldap::params

    package { "${openldap::params::packagename_server}":
        name    => "${openldap::params::packagename_server}",
        ensure  => "${openldap::server::ensure}",
    }

    service { 'openldap':
        name       => "${openldap::params::servicename}",
        enable     => true,
        ensure     => running,
#       hasrestart => "${openldap::params::hasrestart}",
#       pattern    => "${openldap::params::processname}",
#       hasstatus  => "${openldap::params::hasstatus}",
        require    => [ Package["${openldap::params::packagename_server}"],
                      Concat [ "${openldap::params::configfile_server}" ] ],
        subscribe  => File["${openldap::params::configfile}"],
    }

    # SSH PUB KEY SCHEMAS

    file { "${openldap::params::configdir_schema}/openssh-lpk.schema":
        ensure  => "$openldap::server::ensure",
        owner   => "${openldap::params::configfile_owner}",
        group   => "${openldap::params::configfile_group}",
        mode    => "${openldap::params::configdir_schema_mode}",
        source  => 'puppet:///modules/openldap/openssh-lpk_openldap.schema',
        require => Package["${openldap::params::packagename_server}"],
    }


    # SLAPD.CONF creation

    include concat::setup

    concat { "${openldap::params::configfile_server}":
        owner   => "${openldap::params::configfile_owner}",
        group   => "${openldap::params::configfile_group}",
        mode    => "${openldap::params::configfile_mode}",
        require => Package["${openldap::params::packagename_server}"],
    }
    concat::fragment { "slapd_header":
        target  => "${openldap::params::configfile_server}",
        ensure  => "${openldap::server::ensure}",
        content => template("openldap/slapd/10_slapd_header.erb"),
        order   => 10,
    }

    if ("${openldap::server::use_ssl}" == 'yes')
    {
        include 'openssl'

        # generate certificates

        file { "${openldap::params::cert_directory}":
            ensure => "directory",
            owner   => "${openldap::params::databasedir_owner}",
            group   => "${openldap::params::databasedir_group}",
            mode    => "${openldap::params::databasedir_mode}",
            require => Package["${openldap::params::packagename_server}"],
        }

        openssl::x509::generate { "${fqdn}":
            ensure     => "${openldap::server::ensure}",
            commonname => $fqdn,
            owner      => "${openldap::params::databasedir_owner}",
            group      => "${openldap::params::databasedir_group}",
            email      => 'csc-sysadmins@uni.lu',
            basedir    => "${openldap::params::cert_directory}",
            require    => File["${openldap::params::cert_directory}"]
        }

        concat::fragment { "slapd_ssl":
           target  => "${openldap::params::configfile_server}",
           ensure  => "${openldap::server::ensure}",
           content => template("openldap/slapd/20_slapd_ssl.erb"),
           order   => 20,
       }
    }

    openldap::server::database { "${db_name}":
        suffix    => "${openldap::server::suffix}",
        db_number => "${openldap::params::default_db}",
        admin_dn  => "${openldap::server::admin_dn}",
        admin_pwd => "${openldap::server::admin_pwd}",
        syncprov  => "${openldap::server::syncprov}"
    }

    # LDIF DIRECTORY / needed for definitions which use slapadd

    file { "${openldap::params::ldifdir}":
        ensure => "directory",
        owner   => "${openldap::params::databasedir_owner}",
        group   => "${openldap::params::databasedir_group}",
        mode    => "${openldap::params::databasedir_mode}",
        require => Package["${openldap::params::packagename_server}"],
    }

    # ROOTDSE

    # extract dc value from dn
    $dc = regsubst("${openldap::server::suffix}",'^dc=([^,]*).*$','\1')
    openldap::server::root-entry { "${openldap::server::suffix}":
        dc        => $dc,
        o         => $dc,
        desc      => "Root of the ${db_name} ldap directory",
        require   => File["${openldap::params::ldifdir}"],
    }

    # ADMIN ENTRY

    # extract cn value from dn
    $cn = regsubst("${openldap::server::admin_dn}",'^cn=([^,]*).*$','\1')
    # $cn = generate("echo ${openldap::server::admin_dn} | grep -o -e '^cn=[^,]*' | tail -c +4")
    openldap::server::admin-entry { "${openldap::server::admin_dn}":
        cn        => $cn,
        desc      => 'Administrator of this ldap server',
        admin_pwd => "${openldap::server::admin_pwd}"
    }

}


# ------------------------------------------------------------------------------
# = Class: openldap::server::debian
#
# Specialization class for Debian systems
class openldap::server::debian inherits openldap::server::common {

    # Use the good old slapd.conf file !
    augeas { "/etc/default/slapd":
        context => "/files//etc/default/slapd",
        changes => "set SLAPD_CONF '${openldap::params::configfile_server}'",
        onlyif  => "get SLAPD_CONF != '${openldap::params::configfile_server}'",
        notify => Service['openldap'],
        require    => Package["${openldap::params::packagename_server}"],
    }
 
    # Delete the default database files
    exec { "bash -c \"rm ${openldap::params::databasedir}/{DB_CONFIG,__db.*,log.*,alock,dn2id.bdb,id2entry.bdb,objectClass.bdb} || true \"":
        path    => "/usr/bin:/usr/sbin:/bin",
        user    => "${openldap::params::databasedir_owner}",
        group   => "${openldap::params::databasedir_group}",
#       unless  => "test ! -f ${openldap::params::databasedir}/DB_CONFIG",
        require => Package["${openldap::params::packagename_server}"],
    }

}

# ------------------------------------------------------------------------------
# = Class: openldap::server::redhat
#
# Specialization class for Redhat systems
class openldap::server::redhat inherits openldap::server::common { }


