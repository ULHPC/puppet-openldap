# File::      <tt>server/root/entry.pp</tt>
# Author::    Hyacinthe Cartiaux (<hyacinthe.cartiaux@uni.lu>)
# Copyright:: Copyright (c) 2011 Hyacinthe Cartiaux
# License::   GPLv3
# ------------------------------------------------------------------------------
# = Define: openldap::server::root::entry
#
# Create the root entry in your DIT
# You are expected to use as name when defining this resource the dn of the rootDSE
#
# == Parameters:
#
# [*ensure*]
#   'present' or 'absent'
#
# [*db_number*]
#   The number of your database, default is 0
#
# [*dc*], [*o*]
#   Name of the organization
#
# [*desc*]
#   Description of the entry
#
# = Usage:
#
#          openldap::server::root::entry { "dc=uni,dc=lu":
#                db_number => "1",
#                dc        => "uni",
#                o         => "uni",
#                desc      => "Root of the uni.lu ldap directory"
#          }
#
# == Warnings
#
# /!\ Always respect the style guide available
# here[http://docs.puppetlabs.com/guides/style_guide]
#
# [Remember: No empty lines between comments and class definition]
#
define openldap::server::root::entry(
    $dc,
    $o,
    $desc,
    $ensure    = 'present',
    $db_number = $openldap::params::default_db
)
{

    include openldap::params

    $dn = $name

    file { "${openldap::params::ldifdir}/root_${dn}.ldif":
      ensure  => $ensure,
      owner   => $openldap::params::configfile_owner,
      group   => $openldap::params::configfile_group,
      mode    => $openldap::params::configfile_mode,
      content => template('openldap/ldif/root.ldif.erb')
    }

    if ($ensure == 'present')
    {
        openldap::server::slapadd { "slapadd ${openldap::params::ldifdir}/root_${dn}.ldif":
          db_number         => $db_number,
          configfile_server => $openldap::params::configfile_server,
          ldif_file         => "${openldap::params::ldifdir}/root_${dn}.ldif"
        }
    }
}

