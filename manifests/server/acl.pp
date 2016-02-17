# File::      <tt>server/acl.pp</tt>
# Author::    Hyacinthe Cartiaux (<hyacinthe.cartiaux@uni.lu>)
# Copyright:: Copyright (c) 2011 Hyacinthe Cartiaux
# License::   GPLv3
# ------------------------------------------------------------------------------
# = Define: openldap::server::acl
#
# Defines ACL for your ldap tree
#
# == Parameters:
#
# [*db_number*]:
#   The number of the database which will be affected by the ACL
#
# [*what*]
#   Entity managed by the ACL
#
# [*who*]
#   Hash table which associates users and their rights
#
# [*anonymous*]
#   Authorize anonymous read (yes) or not (no)
#
# [*order*]
#   Number of the ACL, used to order ACLs in the configuration file.
#   Value must be comprised between 0 and 8.
#
# = Usage:
#
#          openldap::server::acl { "password protection":
#                db_number => '1',
#                what      => 'userPassword,shadowLastChange',
#                who       => { 'cn=admin,dc=uni,dc=lu' => 'write',
#                               'self' => 'write' },
#                anonymous => "no",
#                order     => 0
#          }
#
# == Warnings
#
# /!\ Always respect the style guide available
# here[http://docs.puppetlabs.com/guides/style_guide]
#
# [Remember: No empty lines between comments and class definition]
#
define openldap::server::acl(
    $what,
    $who,
    $order,
    $db_number = '1',
    $anonymous = 'no'
)
{

    include openldap::params

    if ! ( $anonymous in [ 'yes', 'no' ]) {
        fail("openldap::server::acl 'anonymous' parameter must be set to either 'yes' or 'no'")
    }

    $fragment_number = (4 + $db_number) * 10 + 1 + $order
    concat::fragment { "slapd_acl_${name}":
        ensure  => $openldap::server::ensure,
        target  => $openldap::params::configfile_server,
        content => template('openldap/slapd/45_slapd_acl.erb'),
        order   => $fragment_number,
    }

}

