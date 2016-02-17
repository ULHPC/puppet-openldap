# File::      <tt>server/common.pp</tt>
# Author::    S. Varrette, H. Cartiaux, V. Plugaru, S. Diehl aka. UL HPC Management Team (hpc-sysadmins@uni.lu)
# Copyright:: Copyright (c) 2016 S. Varrette, H. Cartiaux, V. Plugaru, S. Diehl aka. UL HPC Management Team
# License::   Gpl-3.0
#
# ------------------------------------------------------------------------------
# = Class: openldap::server::common
#
# Base class to be inherited by the other openldap::server classes
#
# Note: respect the Naming standard provided here[http://projects.puppetlabs.com/projects/puppet/wiki/Module_Standards]
class openldap::server::common {

    # Load the variables used in this module. Check the openldap-params.pp file
    require openldap::params

    package { $openldap::params::packagename_server:
        ensure => $openldap::server::ensure,
        name   => $openldap::params::packagename_server,
    }

    service { 'openldap':
        ensure    => running,
        name      => $openldap::params::servicename,
        enable    => true,
#       hasrestart => "${openldap::params::hasrestart}",
#       pattern    => "${openldap::params::processname}",
#       hasstatus  => "${openldap::params::hasstatus}",
        require   => [  Package[ $openldap::params::packagename_server ],
                        Concat [ $openldap::params::configfile_server  ],
                        File   ["${openldap::params::databasedir}/${openldap::server::db_name}"]
                      ],
        subscribe => File[$openldap::params::configfile_server]
    }

    # SSH PUB KEY SCHEMAS

    file { "${openldap::params::configdir_schema}/openssh-lpk.schema":
        ensure  => $openldap::server::ensure,
        owner   => $openldap::params::configfile_owner,
        group   => $openldap::params::configfile_group,
        mode    => $openldap::params::configdir_schema_mode,
        source  => 'puppet:///modules/openldap/openssh-lpk_openldap.schema',
        require => Package[$openldap::params::packagename_server],
    }


    # SLAPD.CONF creation

    concat { $openldap::params::configfile_server:
        owner   => $openldap::params::configfile_owner,
        group   => $openldap::params::configfile_group,
        mode    => $openldap::params::configfile_mode,
        require => Package[$openldap::params::packagename_server],
    }
    concat::fragment { 'slapd_header':
        ensure  => $openldap::server::ensure,
        target  => $openldap::params::configfile_server,
        content => template('openldap/slapd/10_slapd_header.erb'),
        order   => 10,
    }

    # Set up SSL

    file { $openldap::params::cert_directory:
        ensure  => 'directory',
        owner   => $openldap::params::databasedir_owner,
        group   => $openldap::params::databasedir_group,
        mode    => $openldap::params::databasedir_mode,
        require => Package[$openldap::params::packagename_server],
    }

    $ssl_certfile   = "${openldap::params::cert_directory}/${::fqdn}_cert.pem"
    $ssl_keyfile    = "${openldap::params::cert_directory}/${::fqdn}_key.pem"

    if ($openldap::server::use_ssl               == 'yes' and
        $openldap::server::ssl_certfile_source   == ''    and
        $openldap::server::ssl_keyfile_source    == ''    and
        $openldap::server::ssl_cacertfile_source == ''     )
    {
        include 'openssl'
        $ssl_cacertfile = $openssl::params::default_ssl_cacert

        # generate certificates

        openssl::x509::generate { $::fqdn:
            ensure     => $openldap::server::ensure,
            commonname => $::fqdn,
            owner      => $openldap::params::databasedir_owner,
            group      => $openldap::params::databasedir_group,
            email      => 'csc-sysadmins@uni.lu',
            basedir    => $openldap::params::cert_directory,
            require    => File[$openldap::params::cert_directory]
        }

    }
    elsif ($openldap::server::use_ssl            == 'yes' and
        $openldap::server::ssl_certfile_source   != ''    and
        $openldap::server::ssl_keyfile_source    != ''    and
        $openldap::server::ssl_cacertfile_source != ''     )
    {
        $ssl_cacertfile = "${openldap::params::cert_directory}/${::fqdn}_cacert.pem"

        # The optional source URL of the certificate has been passed
        file { $ssl_certfile:
            ensure  => 'file',
            owner   => $openldap::params::databasedir_owner,
            group   => $openldap::params::databasedir_group,
            mode    => '0644',
            source  => $openldap::server::ssl_certfile_source,
            require => File[$openldap::params::cert_directory]
        }
        # The associated keyfile should have been passed too...
        file { $ssl_keyfile:
            ensure  => 'file',
            owner   => $openldap::params::databasedir_owner,
            group   => $openldap::params::databasedir_group,
            mode    => '0600',
            source  => $openldap::server::ssl_keyfile_source,
            require => File[$openldap::params::cert_directory]
        }
        file { $ssl_cacertfile:
            ensure  => 'file',
            owner   => $openldap::params::databasedir_owner,
            group   => $openldap::params::databasedir_group,
            mode    => '0600',
            source  => $openldap::server::ssl_cacertfile_source,
            require => File[$openldap::params::cert_directory]
        }

    }

    if ($openldap::server::use_ssl == 'yes')
    {
        concat::fragment { 'slapd_ssl':
          ensure  => $openldap::server::ensure,
          target  => $openldap::params::configfile_server,
          content => template('openldap/slapd/20_slapd_ssl.erb'),
          order   => 20,
        }
    }

    # End of SSL configuration

    # DB creation

    openldap::server::database { $openldap::server::db_name:
        suffix    => $openldap::server::suffix,
        db_number => $openldap::params::default_db,
        admin_dn  => $openldap::server::admin_dn,
        admin_pwd => $openldap::server::admin_pwd,
        syncprov  => $openldap::server::syncprov,
        memberof  => $openldap::server::memberof
    }

    # LDIF DIRECTORY / needed for definitions which use slapadd

    file { $openldap::params::ldifdir:
        ensure  => 'directory',
        owner   => $openldap::params::databasedir_owner,
        group   => $openldap::params::databasedir_group,
        mode    => $openldap::params::databasedir_mode,
        require => Package[$openldap::params::packagename_server],
    }

    # ROOTDSE

    # extract dc value from dn
    $dc = regsubst($openldap::server::suffix,'^dc=([^,]*).*$','\1')
    openldap::server::root::entry { $openldap::server::suffix:
        dc      => $dc,
        o       => $dc,
        desc    => "Root of the ${openldap::server::db_name} ldap directory",
        require => File[$openldap::params::ldifdir],
    }

    # ADMIN ENTRY

    if ($openldap::server::admin_create == 'yes')
    {
        # extract cn value from dn
        $cn = regsubst($openldap::server::admin_dn,'^cn=([^,]*).*$','\1')
        # $cn = generate("echo ${openldap::server::admin_dn} | grep -o -e '^cn=[^,]*' | tail -c +4")
        openldap::server::admin::entry { $openldap::server::admin_dn:
            cn        => $cn,
            desc      => 'Administrator of this ldap server',
            admin_pwd => $openldap::server::admin_pwd,
            require   => Openldap::Server::Root::Entry[$openldap::server::suffix]
        }
    }

}
