# File::      <tt>openldap-server-slapadd.pp</tt>
# Author::    Hyacinthe Cartiaux (<hyacinthe.cartiaux@uni.lu>)
# Copyright:: Copyright (c) 2011 Hyacinthe Cartiaux
# License::   GPLv3
# ------------------------------------------------------------------------------
# = Define: openldap::server::slapadd
#
# Execute a slapadd command with the given parameters
#
# == Parameters:
#
# [*db_number*]
#   The number of your database, default is ${openldap::params::default_db}
#
# [*configfile_server*]
#   Name of slapd configuration file
#
# [*ldif_file*]
#   ldif file
#
# = Usage:
#
#          openldap::server::slapadd { "slapadd of ou=People,dc=uni,dc=lu":
#                db_number         => "1",
#                configfile_server => "/etc/ldap/slapd.conf",
#                ldif_file         => "/var/lib/ldif/peoplestruct.ldif"
#          }
#
# == Warnings
#
# /!\ Always respect the style guide available
# here[http://docs.puppetlabs.com/guides/style_guide]
#
# [Remember: No empty lines between comments and class definition]
#
define openldap::server::slapadd(
    $db_number         = $openldap::params::default_db,
    $configfile_server = $openldap::params::configfile_server,
    $ldif_file
)
{

    include openldap::params

    exec { "slapadd -f ${configfile_server} -n ${db_number} -l ${ldif_file}":
      path    => '/sbin:/usr/bin:/usr/sbin:/bin',
      command => "service slapd stop ; 
                  slapadd -f ${configfile_server} -n ${db_number} -l ${ldif_file} ;
                  chown -R ${openldap::params::databasedir_owner}:${openldap::params::databasedir_group} ${openldap::params::databasedir}
                  touch ${ldif_file}.puppet ; 
                  service slapd start || true",
      unless  => "test -f ${ldif_file}.puppet",
      user    => 'root',
      group   => 'root',
#     user    => "${openldap::params::databasedir_owner}",
#     group   => "${openldap::params::databasedir_group}",
      require => [ File[$ldif_file],
                   Concat [$openldap::params::configfile_server],
                   Service ['openldap']  ],
    }
}
