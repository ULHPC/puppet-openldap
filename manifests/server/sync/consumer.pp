# File::      <tt>server/sync/consumer.pp</tt>
# Author::    Hyacinthe Cartiaux (<hyacinthe.cartiaux@uni.lu>)
# Copyright:: Copyright (c) 2011 Hyacinthe Cartiaux
# License::   GPLv3
# ------------------------------------------------------------------------------
# = Define: openldap::server::sync::consumer
#
# Replicate a branch in your ldap database
#
# == Parameters:
#
# [*provider*]
#   Ldap server URI of the provider
#
# [*db_number*]
#   Number of the database in which the consumer will be defined,
#   default is 1 (first database)
#
# [*use_ssl*]
#   Type of connection, 'yes' for SSL (start tls), 'no' for unsecure connection.
#   SSL must be configured properly on the server to use this feature.
#
# ['rid']
#   ID of the consumer, must be unique (among all consumers)
#
# ['searchbase']
#   branch to be replicated
#
# [*binddn*]
#   The DN of the user which whill be used to log in
#
# [*credentials*]
#   The password of the user pointed by binddn
#
# = Usage:
#
#          openldap::server::sync::consumer { "ldap-accounts replica":
#                provider    => "ldap://ldap-accounts.uni.lux",
#                db_number   => "1",
#                use_ssl     => "yes",
#                rid         => "000",
#                searchbase  => "ou=People,dc=uni,dc=lu"
#                binddn      => "cn=admin,dc=uni,dc=lu",
#                credentials => "Ko2ewKo2ew",
#          }
#
# == Warnings
#
# /!\ Always respect the style guide available
# here[http://docs.puppetlabs.com/guides/style_guide]
#
# [Remember: No empty lines between comments and class definition]
#
define openldap::server::sync::consumer(
    $provider,
    $searchbase,
    $binddn,
    $credentials,
    $db_number   = $openldap::params::default_db,
    $use_ssl     = $openldap::params::ssl,
    $rid         = '000'
)
{

    include ::openldap::params

    if ( $use_ssl == 'yes' and
#             $openldap::server::use_ssl               == 'yes' and
          ! ( $openldap::server::ssl_certfile_source   != ''    and
              $openldap::server::ssl_keyfile_source    != ''    and
              $openldap::server::ssl_cacertfile_source != ''    )
            )
    {
        fail('Server must be properly configured to use SSL')
    }

    $ssl_certfile   = "${openldap::params::cert_directory}/${::fqdn}_cert.pem"
    $ssl_cacertfile = "${openldap::params::cert_directory}/${::fqdn}_cacert.pem"
    $ssl_keyfile    = "${openldap::params::cert_directory}/${::fqdn}_key.pem"

    $fragment_db    = (4 + $db_number) * 10 + 9

    concat::fragment { "slapd_sync_consumer_${db_number}_${rid}":
        ensure  => $openldap::server::ensure,
        target  => $openldap::params::configfile_server,
        content => template('openldap/slapd/50_slapd_syncrep.erb'),
        order   => $fragment_db,
    }

}

