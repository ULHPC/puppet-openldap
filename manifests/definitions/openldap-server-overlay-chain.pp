# File::      <tt>openldap-server-overlay-chain.pp</tt>
# Author::    Hyacinthe Cartiaux (<hyacinthe.cartiaux@uni.lu>)
# Copyright:: Copyright (c) 2011 Hyacinthe Cartiaux
# License::   GPLv3
# ------------------------------------------------------------------------------
# = Define: openldap::server::overlay-chain
#
# Configure a chain overlay for the server. Allow the server to chase referrals
# instead of the client.
# You are expected to use as name when defining this resource the target ldap 
# server URI.
#
# == Parameters:
#
# [*use_ssl*]
#   Type of connection, 'yes' for SSL (start tls), 'no' for unsecure connection.
#
# [*binddn*]
#   The DN of the user which whill be used to log in
#
# [*credentials*]
#   The password of the user pointed by binddn
#
# = Usage:
#
#          openldap::server::overlay-chain { "ldap://ldap-accounts.uni.lux":
#                ssl         => "yes",
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
define openldap::server::overlay-chain(
    $use_ssl = 'yes',
    $binddn,
    $credentials
)
{

    include openldap::params

    # $name is provided by define invocation and is the URI of the ldap server 
    $uri  = "${name}"

    if ! ( "${use_ssl}" in [ 'yes', 'no' ]) {
          fail("openldap::server::overlay-chain 'ssl' parameter must be set to either 'yes' or 'no'")
    }
    if (! "${binddn}") { 
          fail("openldap::server::overlay-chain 'binddn' parameter must not be empty")
    }
    if (! "${credentials}") {
          fail("openldap::server::overlay-chain 'credentials' parameter must not be empty")
    }

    concat::fragment { "slapd_overlay_chain":
         target  => "${openldap::params::configfile_server}",
         ensure  => "${openldap::server::ensure}",
         content => template("openldap/slapd/30_slapd_overlay_chain.erb"),
         order   => 30,
    }

}

