# File::      <tt>openldap-server-alias-entry.pp</tt>
# Author::    Hyacinthe Cartiaux (<hyacinthe.cartiaux@uni.lu>)
# Copyright:: Copyright (c) 2011 Hyacinthe Cartiaux
# License::   GPLv3
# ------------------------------------------------------------------------------
# = Define: openldap::server::ou-entry
#
# Create the desired alias entry in your DIT
# You are expected to use as name when defining this resource the dn of the entry
#
# == Parameters:
#
# [*ensure*]
#   'present' or 'absent'
#
# [*db_number*]
#   The number of your database, default is ${openldap::params::default_db}
#
# [*target*]
#   Target of the alias
#
# = Usage:
#
#          openldap::server::alias-entry { "ou=Chaos,ou=Clusters,ou=HPC,ou=Services,dc=uni,dc=lu":
#                db_number => "1",
#                target    => "ou=Gaia,ou=Clusters,ou=HPC,ou=Services,dc=uni,dc=lu",
#          }
#
# == Warnings
#
# /!\ Always respect the style guide available
# here[http://docs.puppetlabs.com/guides/style_guide]
#
# [Remember: No empty lines between comments and class definition]
#
define openldap::server::alias-entry(
    $ensure    = 'present',
    $db_number = $openldap::params::default_db,
    $target
)
{

    include openldap::params

    $dn = $name
    $attr = regsubst($dn,'^([^=]*)=.*$','\1')
    $value = regsubst($dn,"^${attr}=([^,]*).*$",'\1')

    file { "${openldap::params::ldifdir}/alias_${dn}.ldif":
       ensure  => $ensure,
       owner   => $openldap::params::configfile_owner,
       group   => $openldap::params::configfile_group,
       mode    => $openldap::params::configfile_mode,
       content => template('openldap/ldif/alias.ldif.erb')
    }

    if ($ensure == 'present')
    {
       openldap::server::slapadd { "slapadd ${openldap::params::ldifdir}/alias_${dn}.ldif":
          db_number         => $db_number,
          configfile_server => $openldap::params::configfile_server,
          ldif_file         => "${openldap::params::ldifdir}/alias_${dn}.ldif",
          require           => Openldap::Server::Root-entry[$openldap::server::suffix]
       }
    }
}

