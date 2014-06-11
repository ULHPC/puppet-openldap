# File::      <tt>openldap-server-database.pp</tt>
# Author::    Hyacinthe Cartiaux (<hyacinthe.cartiaux@uni.lu>)
# Copyright:: Copyright (c) 2011 Hyacinthe Cartiaux
# License::   GPLv3
# ------------------------------------------------------------------------------
# = Define: openldap::server::database
#
# Configure a new database managed by your openldap server.
# You are expected to use as name when defining this resource the name of the database
#
# == Parameters:
#
# [*suffix*]
#   The suffix (DN) of your directory tree
#
# [*db_number*]
#   The number of your database, used internally to order the configuration file.
#   Note that the first database #0 is reserved by slapd for configuration,
#   openldap::server define database #1, and additionnal defined database must
#   be #2 or superior
#
# [*admin_dn*]
#   The DN of the user which will have administrator rights on the database
#
# [*admin_pwd*]
#   The password of the user $admin_dn
#
# [*syncprov*]
#   Enable the syncprov overlay for this database
#
# [*memberof*]
#   Enable the memberof overlay for this database
#
#
# = Usage:
#
#          openldap::server::database { "uni.lu"
#                suffix    => "dc=uni,dc=lu",
#                db_number => "1",
#                admin_dn  => "cn=admin,dc=uni,dc=lu",
#                admin_pwd => "Ko2ewKo2ew",
#                syncprov  => "yes",
#                memberof  => "yes"
#          }
#
# == Warnings
#
# /!\ Always respect the style guide available
# here[http://docs.puppetlabs.com/guides/style_guide]
#
# [Remember: No empty lines between comments and class definition]
#
define openldap::server::database(
    $suffix,
    $db_number,
    $admin_dn,
    $admin_pwd,
    $syncprov,
    $memberof
)
{

    include openldap::params

    if (! "${suffix}") {
         fail("openldap::server::database 'suffix' parameter must not be empty")
    }
    if (! "${db_number}") {
         fail("openldap::server::database 'db_number' parameter must not be set")
    }
    if (! "${admin_dn}") {
         fail("openldap::server::database 'binddn' parameter must not be empty")
    }
    if (! "${admin_pwd}") {
         fail("openldap::server::database 'credentials' parameter must not be empty")
    }
    if ! ($syncprov in [ 'yes', 'no' ]) {
         fail("openldap::server::database 'syncprov' parameter must be set to either 'yes' or 'no'")
    }
    if ! ($memberof in [ 'yes', 'no' ]) {
         fail("openldap::server::database 'memberof' parameter must be set to either 'yes' or 'no'")
    }


    # Hashed password

    $hashed_password = slappasswd("${openldap::server::salt}", $admin_pwd)

    file { "/root/.openldap_pwd_${name}":
        ensure  => "${openldap::server::ensure}",
        owner   => "${openldap::params::configfile_owner}",
        mode    => "${openldap::params::configfile_mode}",
        content => "${admin_pwd}"
    }
    file { "/root/.openldap_admindn_${name}":
        ensure  => "${openldap::server::ensure}",
        owner   => "${openldap::params::configfile_owner}",
        mode    => "${openldap::params::configfile_mode}",
        content => "${admin_dn}"
    }


    # Database directory

    file { "${openldap::params::databasedir}/${name}":
        ensure  => "directory",
        owner   => "${openldap::params::databasedir_owner}",
        group   => "${openldap::params::databasedir_group}",
        mode    => "${openldap::params::databasedir_mode}",
        require => Package["${packagename}"],
    }

    $fragment_db = (4 + $db_number) * 10
    concat::fragment { "slapd_overlay_database_${db_number}":
        target  => "${openldap::params::configfile_server}",
        ensure  => "${openldap::server::ensure}",
        content => template("openldap/slapd/40_slapd_database.erb"),
        order   => $fragment_db,
    }

    $fragment_memberof = $fragment_db + 8
    if ("${memberof}" == 'yes')
    {
        concat::fragment { "slapd_memberof_${db_number}":
            target  => "${openldap::params::configfile_server}",
            ensure  => "${openldap::server::ensure}",
            content => template("openldap/slapd/50_slapd_syncprov.erb"),
            order   => $fragment_memberof,
        }
    }

    $fragment_syncprov = $fragment_memberof + 1
    if ("${syncprov}" == 'yes')
    {
        concat::fragment { "slapd_syncprov_${db_number}":
            target  => "${openldap::params::configfile_server}",
            ensure  => "${openldap::server::ensure}",
            content => template("openldap/slapd/50_slapd_syncprov.erb"),
            order   => $fragment_syncprov,
        }
    }
}

