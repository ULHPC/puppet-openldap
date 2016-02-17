# File::      <tt>client.pp</tt>
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
#             unix_auth   => 'yes',
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
        $ensure                = $openldap::params::ensure,
        $base                  = $openldap::params::suffix,
        $uri                   = $openldap::params::uri,
        $use_ssl               = $openldap::params::ssl,
        $ssl_cacertfile_source = '',
        $unix_auth             = $openldap::params::unix_auth,
        $base_passwd           = $openldap::params::base_passwd,
        $base_group            = $openldap::params::base_group,
        $scope                 = $openldap::params::scope
        ) inherits openldap::params
{
    info ("Configuring openldap (with ensure = ${ensure})")

    if ! ($ensure in [ 'present', 'absent' ]) {
        fail("openldap 'ensure' parameter must be set to either 'absent' or 'present'")
    }

    if ! ($unix_auth in [ 'yes', 'no' ]) {
        fail("openldap 'unix_auth' parameter must be set to either 'yes' or 'no'")
    }

    if ! ($scope in [ 'one', 'sub' ]) {
        fail("openldap 'unix_auth' parameter must be set to either 'one' or 'sub'")
    }

#    if ($unix_auth == 'yes' and ($base_passwd == '' or $base_group == '' or $scope == ''))
#    {
#        fail("openldap 'base_passwd', 'base_group' and 'scope' parameters must be set when unix_auth value is 'yes'")
#    }

    case $::operatingsystem {
        debian, ubuntu: { include openldap::client::common::debian }
        redhat, centos: { include openldap::client::common::redhat }
        default: {
            fail("Module ${module_name} is not supported on ${::operatingsystem}")
        }
    }
}

