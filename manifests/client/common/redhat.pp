# File::      <tt>client/common/redhat.pp</tt>
# Author::    S. Varrette, H. Cartiaux, V. Plugaru, S. Diehl aka. UL HPC Management Team (hpc-sysadmins@uni.lu)
# Copyright:: Copyright (c) 2016 S. Varrette, H. Cartiaux, V. Plugaru, S. Diehl aka. UL HPC Management Team
# License::   Gpl-3.0
#
# Specialization class for Redhat systems
# ------------------------------------------------------------------------------
# = Class: openldap::client::common::redhat
#
# Specialization class for Redhat systems
class openldap::client::common::redhat inherits openldap::client::common {

    file {$openldap::params::configfile_client_alternate:
        ensure => 'link',
        owner  => $openldap::params::configfile_client_owner,
        group  => $openldap::params::configfile_client_group,
        target => $openldap::params::configfile_client,
    }

    # /!\ To be tested !
    # configure PAM for LDAP
    # augeas { "authconfig":
    #   require => Augeas["ldapauth"],
    #   context => "/files/etc/sysconfig/authconfig",
    #   changes => [
    #     "set USELDAP yes",
    #     "set USELDAPAUTH yes",
    #     "set USEMKHOMEDIR yes",
    #     "set USELOCAUTHORIZE yes",
    #   ],
    # }
    # exec { "authconfig":
    #   path => "/usr/bin:/usr/sbin:/bin",
    #   command => "authconfig --updateall",
    #   subscribe => Augeas["authconfig"],
    #   refreshonly => true,
    # }

}
