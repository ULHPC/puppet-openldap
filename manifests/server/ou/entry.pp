# File::      <tt>server/ou/entry.pp</tt>
# Author::    Hyacinthe Cartiaux (<hyacinthe.cartiaux@uni.lu>)
# Copyright:: Copyright (c) 2011 Hyacinthe Cartiaux
# License::   GPLv3
# ------------------------------------------------------------------------------
# = Define: openldap::server::ou::entry
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
#          openldap::server::ou::entry { "ou=People,dc=uni,dc=lu":
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
define openldap::server::ou::entry(
    $ou,
    $desc,
    $ensure    = 'present',
    $db_number = $openldap::params::default_db
)
{

    include openldap::params

    $dn = $name

    file { "${openldap::params::ldifdir}/ou_${dn}.ldif":
      ensure  => $ensure,
      owner   => $openldap::params::configfile_owner,
      group   => $openldap::params::configfile_group,
      mode    => $openldap::params::configfile_mode,
      content => template('openldap/ldif/ou.ldif.erb')
    }

    if ($ensure == 'present')
    {
      openldap::server::slapadd { "slapadd ${openldap::params::ldifdir}/ou_${dn}.ldif":
        db_number         => $db_number,
        configfile_server => $openldap::params::configfile_server,
        ldif_file         => "${openldap::params::ldifdir}/ou_${dn}.ldif",
        require           => Openldap::Server::Root::Entry[$openldap::server::suffix]
      }
    }
}

