# File::      <tt>server.pp</tt>
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
# $ssl_certfile_source::
#  Only meaningfull if use_ssl = true
#  optional source URL of the certificate, if the default self-signed generated
#  one doesn't suit.
#  If this parameter IS NOT specified, then it is assumed one expect the
#  generation of a self-signed certificate.
#
# $ssl_keyfile_source::
#  Only meaningfull if use_ssl = true and ssl_certfile_source != ''
#   optional source URL of the private key.
#
# $ssl_cacertfile_source::
#   optional source URL of the CA certificate.
#
# $db_name:: *Default*: 'uni.lu'. Name of the database, used in configuration file
#
# $suffix:: *Default*: 'dc=uni,dc=lu'. suffix of the rootDSE
#
# $admin_create:: *Default*: 'yes'. Create or not the admin entity
#
# admin_dn:: *Default*: 'cn=admin,dc=uni,dc=lu', dn of the admin entry of the database
#
# admin_pwd:: password of the administrator
#
# salt:: salt value for the hash algorithm
#
# syncprov:: *Default*: 'no', if set to 'yes', the openldap server will be master for replication
#
# memberof:: *Default*: 'no', if set to 'yes', the overlay memberof will be enabled
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
#         salt      => 'r4nd0m',
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
    $db_name   = $openldap::params::db_name,
    $suffix    = $openldap::params::suffix,
    $admin_create = $openldap::params::admin_create,
    $admin_dn  = $openldap::params::admin_dn,
    $admin_pwd = $openldap::params::admin_pwd,
    $syncprov  = $openldap::params::syncprov,
    $memberof  = $openldap::params::memberof,
    $salt      = $openldap::params::salt,
    $use_ssl               = $openldap::params::ssl,
    $ssl_certfile_source   = '',
    $ssl_keyfile_source    = '',
    $ssl_cacertfile_source = ''
    ) inherits openldap::params
{
    info ("Configuring openldap::server (with ensure = ${ensure})")

    if ! ($ensure in [ 'present', 'absent' ]) {
        fail("openldap 'ensure' parameter must be set to either 'absent' or 'present'")
    }

    if ($openldap::server::use_ssl == 'yes'
      and ! ( $ssl_certfile_source == '' and
        $ssl_keyfile_source        == '' and
        $ssl_cacertfile_source     == '' )
      and ! ( $ssl_certfile_source != '' and
        $ssl_keyfile_source        != '' and
        $ssl_cacertfile_source     != '' )
      )
    {
        fail('openldap ssl source parameters must be all empty to automatically generate a self signed certificate, or all filled to specify your own files')
    }

    case $::operatingsystem {
        'debian', 'ubuntu':         { include ::openldap::server::common::debian }
        default: {
            fail("Module ${module_name} is not supported on ${::operatingsystem}")
        }
    }
}

