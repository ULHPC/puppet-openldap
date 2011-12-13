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
# $unix_auth:: *Default*: 'no'. Configure pam and nss to use ldap auth
#
# $base_passwd:: *Default*: 'ou=People,${base}'. Passwd/shadow branch
#
# $base_group:: *Default*: 'ou=Groups,${base}'. Groups branch
#
# $scope:: *Default*: 'one'. Scope, must be set to 'one' or 'sub'
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
#             ensure      => 'present',
#             base        => 'dc=uni,dc=lu',
#             uri         => 'ldap://localhost:389',
#             use_ssl     => 'yes',
#             unix_auth   => 'yes'
#             base_passwd => 'ou=People,ou=Gaia,ou=Cluster,ou=HPC,ou=Services,dc=uni,dc=lu',
#             base_group  => 'ou=Groups,ou=Gaia,ou=Cluster,ou=HPC,ou=Services,dc=uni,dc=lu',
#             scope       => 'sub'
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
        $ensure      = $openldap::params::ensure,
        $base        = $openldap::params::suffix,
        $uri         = $openldap::params::uri,
        $use_ssl     = $openldap::params::ssl,
        $unix_auth   = $openldap::params::unix_auth,
        $base_passwd = $openldap::params::base_passwd,
        $base_group  = $openldap::params::base_group,
        $scope       = $openldap::params::scope
        ) inherits openldap::params
{
    info ("Configuring openldap (with ensure = ${ensure})")

    if ! ("${ensure}" in [ 'present', 'absent' ]) {
        fail("openldap 'ensure' parameter must be set to either 'absent' or 'present'")
    }

    if ! ("${unix_auth}" in [ 'yes', 'no' ]) {
        fail("openldap 'unix_auth' parameter must be set to either 'yes' or 'no'")
    }

    if ! ("${scope}" in [ 'one', 'sub' ]) {
        fail("openldap 'unix_auth' parameter must be set to either 'one' or 'sub'")
    }

#    if ($unix_auth == 'yes' and ($base_passwd == '' or $base_group == '' or $scope == ''))
#    {
#        fail("openldap 'base_passwd', 'base_group' and 'scope' parameters must be set when unix_auth value is 'yes'")
#    }

    case $::operatingsystem {
        debian, ubuntu:         { include openldap::client::debian }
        # redhat, fedora, centos: { include openldap::client::redhat }
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
        owner   => "${openldap::params::configfile_client_owner}",
        group   => "${openldap::params::configfile_client_group}",
        mode    => "${openldap::params::configfile_client_mode}",
        ensure  => "${openldap::client::ensure}",
        content => template("openldap/ldap.conf.erb"),
        require => Package["${openldap::params::packagename_client}"],
    }

    if ($unix_auth == 'yes')
    {

        package { $openldap::params::packagename_unix_auth:
            ensure  => "${openldap::client::ensure}",
        }

        ## LINK ldap.conf / nss / pam
    
        # libnss-ldap.conf
        file {"${openldap::params::configfile_nss}":
            ensure => "link",
            owner  => "${openldap::params::configfile_client_owner}",
            group  => "${openldap::params::configfile_client_group}",
            target => "${openldap::params::configfile_client}",
        }

        file {"${openldap::params::configfile_pam}":
            ensure => "link",
            owner  => "${openldap::params::configfile_client_owner}",
            group  => "${openldap::params::configfile_client_group}",
            target => "${openldap::params::configfile_client}",
        }

        ## NSSWITCH

        # ugly sed commands to edit nsswitch.conf because of missing nsswitch 
        # lense in augeas in Debian Squeeze :( (available in augeas 0.7.4)

        # Passwd
        exec { "sed -s -i 's/passwd:[ ]*\(.*\)$/passwd: \1 ldap # edited by puppet/' /etc/nsswitch.conf":
            path    => "/usr/bin:/usr/sbin:/bin",
            unless  => "grep -e '^passwd:.*ldap.*$' /etc/nsswitch.conf",
        }

        # Group
        exec { "sed -s -i 's/group:[ ]*\(.*\)$/group: \1 ldap # edited by puppet/' /etc/nsswitch.conf":
            path    => "/usr/bin:/usr/sbin:/bin",
            unless  => "grep -e '^group:.*ldap.*$' /etc/nsswitch.conf",
        }
 
        # shadow
        exec { "sed -s -i 's/shadow:[ ]*\(.*\)$/shadow: \1 ldap # edited by puppet/' /etc/nsswitch.conf":
            path    => "/usr/bin:/usr/sbin:/bin",
            unless  => "grep -e '^shadow:.*ldap.*$' /etc/nsswitch.conf",
        }

    }
}


# ------------------------------------------------------------------------------
# = Class: openldap::client::debian
#
# Specialization class for Debian systems
class openldap::client::debian inherits openldap::client::common {

     ## PAM
     # /!\ Debian squeeze : pam configuration files are edited during package installation

     # augeas { "auth-pam_ldap":
     #    context => "/files/etc/pam.d/common-auth",
     #    changes => [
     #            "ins 100000 after *[type='auth'][module='pam_unix.so']",
     #            "set 100000/type auth",
     #            "set 100000/control sufficient",
     #            "set 100000/module pam_ldap.so",
     #            "set 100000/argument use_first_pass"
     #    ],
     #    onlyif  => "match *[type='auth'][module='pam_ldap.so'] size == 0",
     # }

}

# ------------------------------------------------------------------------------
# = Class: openldap::client::redhat
#
# Specialization class for Redhat systems
class openldap::client::redhat inherits openldap::client::common {

    # /!\ To be tested !

    # configure PAM for LDAP
    # augeas { "authconfig":
    #   require => Augeas["ldapauth"],
    #   context => "/files/etc/sysconfig/authconfig",
    #   changes => [
    #     "set USELDAP yes",
    #     "set USELDAPAUTH yes",
    #     "set USEMKHOMEDIR yes",
    #     "set USELOCAUTHORIZE yes”,
    #   ],
    # }
    # exec { "authconfig":
    #   path => "/usr/bin:/usr/sbin:/bin",
    #   command => "authconfig --updateall",
    #   subscribe => Augeas["authconfig"],
    #   refreshonly => true,
    # }

}



