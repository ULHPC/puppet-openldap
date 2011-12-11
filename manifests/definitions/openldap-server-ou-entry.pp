# File::      <tt>openldap-server-ou-entry.pp</tt>
# Author::    Hyacinthe Cartiaux (<hyacinthe.cartiaux@uni.lu>)
# Copyright:: Copyright (c) 2011 Hyacinthe Cartiaux
# License::   GPLv3
# ------------------------------------------------------------------------------
# = Define: openldap::server::ou-entry
#
# Create the desired Organizational Unit entry in your DIT
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
# [*ou*]
#   Name of the ou
#
# [*desc*]
#   Description of the entry
#
# = Usage:
#
#          openldap::server::ou-entry { "ou=People,dc=uni,dc=lu":
#                db_number => "1",
#                ou        => "People",
#                desc      => "Branch which includes all the users"
#          }
#
# == Warnings
#
# /!\ Always respect the style guide available
# here[http://docs.puppetlabs.com/guides/style_guide]
#
# [Remember: No empty lines between comments and class definition]
#
define openldap::server::ou-entry(
    $ensure    = 'present',
    $db_number = "${openldap::params::default_db}",
    $ou,
    $desc
)
{

    include openldap::params

    $dn = $name

    file { "${openldap::params::ldifdir}/ou_${ou}.ldif":
       ensure  => $ensure,
       owner   => "${openldap::params::databasedir_owner}",
       group   => "${openldap::params::databasedir_group}",
       mode    => "${openldap::params::databasedir_mode}",
       content => template('openldap/ldif/ou.ldif.erb')
    }

    if ($ensure == 'present')
    {
       openldap::server::slapadd { "slapadd ${openldap::params::ldifdir}/ou_${ou}.ldif":
          db_number         => "${db_number}",
          configfile_server => "${openldap::params::configfile_server}",
          ldif_file         => "${openldap::params::ldifdir}/ou_${ou}.ldif",
          require   => Openldap::Server::Root-entry["${openldap::server::suffix}"]
       }
    }
}

