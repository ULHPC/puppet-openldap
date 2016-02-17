# ------------------------------------------------------------------------------
# = Class: openldap::server::common::debian
#
# Specialization class for Debian systems
class openldap::server::common::debian inherits openldap::server::common {

    # Use the good old slapd.conf file !
    augeas { 'SLAPD_CONF':
        context => '/files//etc/default/slapd',
        changes => "set SLAPD_CONF '${openldap::params::configfile_server}'",
        onlyif  => "get SLAPD_CONF != '${openldap::params::configfile_server}'",
        notify  => Service['openldap'],
        require => Package[$openldap::params::packagename_server],
    }

    # Enable ldaps://
    if ($openldap::server::use_ssl == 'yes')
    {
        augeas { 'LDAPS':
            context => '/files//etc/default/slapd',
            changes => "set SLAPD_SERVICES \"'ldap:/// ldapi:/// ldaps:///'\"",
            onlyif  => "get SLAPD_SERVICES != 'ldap:/// ldapi:/// ldaps:///'",
            notify  => Service['openldap'],
            require => Package[$openldap::params::packagename_server],
        }
    }

    # Delete the default database files
    exec { "bash -c \"rm ${openldap::params::databasedir}/{DB_CONFIG,__db.*,log.*,alock,dn2id.bdb,id2entry.bdb,objectClass.bdb} || true \"":
        path    => '/usr/bin:/usr/sbin:/bin',
        user    => $openldap::params::databasedir_owner,
        group   => $openldap::params::databasedir_group,
        unless  => "test ! -f ${openldap::params::databasedir}/DB_CONFIG",
        require => Package[$openldap::params::packagename_server],
    }

}
