# File::      <tt>openldap-server-sync-consumer.pp</tt>
# Author::    Hyacinthe Cartiaux (<hyacinthe.cartiaux@uni.lu>)
# Copyright:: Copyright (c) 2011 Hyacinthe Cartiaux
# License::   GPLv3
# ------------------------------------------------------------------------------
# = Define: openldap::server::sync-consumer
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
# [*ssl*]
#   Type of connection, 'yes' for SSL (start tls), 'no' for unsecure connection.
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
#          openldap::server::sync-consumer { "ldap-accounts replica":
#                provider    => "ldap://ldap-accounts.uni.lux",
#                db_number   => "1",
#                ssl         => "yes",
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
define openldap::server::sync-consumer(
    $provider,
    $db_number = "${openldap::params::default_db}",
    $use_ssl   = "${openldap::params::ssl}",
    $rid       = '000',
    $searchbase,
    $binddn,
    $credentials
)
{

    include openldap::params

    $fragment_db = (4 + $db_number) * 10 + 9
    concat::fragment { "slapd_sync_consumer_${db_number}_${rid}":
        target  => "${openldap::params::configfile_server}",
        ensure  => "${openldap::server::ensure}",
        content => template("openldap/slapd/50_slapd_syncrep.erb"),
        order   => $fragment_db,
    }

}

