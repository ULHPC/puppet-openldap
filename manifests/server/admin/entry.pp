# File::      <tt>server/admin/entry.pp</tt>
# Author::    Hyacinthe Cartiaux (<hyacinthe.cartiaux@uni.lu>)
# Copyright:: Copyright (c) 2011 Hyacinthe Cartiaux
# License::   GPLv3
# ------------------------------------------------------------------------------
# = Define: openldap::server::admin::entry
#
# Create a simpleSecurityObject entry
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
# [*cn*]
#   cn field of the entry
#
# [*admin_pwd*]
#   password of the administrator (in clear form, hashed in the definition)
#
# [*desc*]
#   Description of the entry
#
# = Usage:
#
#          openldap::server::admin::entry { "cn=admin,dc=uni,dc=lu":
#                cn         => "admin",
#                desc       => "Administrator of this ldap server",
#                admin_pwd  => "<RANDOM AND SECURE PASSWORD>"
#          }
#
# == Warnings
#
# /!\ Always respect the style guide available
# here[http://docs.puppetlabs.com/guides/style_guide]
#
# [Remember: No empty lines between comments and class definition]
#
define openldap::server::admin::entry(
    $cn,
    $desc,
    $admin_pwd,
    $ensure    = 'present',
    $db_number = $openldap::params::default_db
)
{

    include openldap::params

    $dn = $name
    $hashed_password = slappasswd($openldap::server::salt, $admin_pwd)

    file { "${openldap::params::ldifdir}/admin_${dn}.ldif":
      ensure  => $ensure,
      owner   => $openldap::params::configfile_owner,
      group   => $openldap::params::configfile_group,
      mode    => $openldap::params::configfile_mode,
      content => template('openldap/ldif/admin.ldif.erb')
    }
    if ($ensure == 'present')
    {
        openldap::server::slapadd { "slapadd ${openldap::params::ldifdir}/admin_${dn}.ldif":
          db_number         => $db_number,
          configfile_server => $openldap::params::configfile_server,
          ldif_file         => "${openldap::params::ldifdir}/admin_${dn}.ldif",
          require           => Openldap::Server::Root::Entry[$openldap::server::suffix]
        }
    }
}

