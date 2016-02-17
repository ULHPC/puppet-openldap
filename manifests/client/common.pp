# File::      <tt>client/common.pp</tt>
# Author::    S. Varrette, H. Cartiaux, V. Plugaru, S. Diehl aka. UL HPC Management Team (hpc-sysadmins@uni.lu)
# Copyright:: Copyright (c) 2016 S. Varrette, H. Cartiaux, V. Plugaru, S. Diehl aka. UL HPC Management Team
# License::   Gpl-3.0
#
# ------------------------------------------------------------------------------
# = Class: openldap::common
#
# Base class to be inherited by the other openldap classes, containing the common code.
#
# Note: respect the Naming standard provided here[http://projects.puppetlabs.com/projects/puppet/wiki/Module_Standards]
# ------------------------------------------------------------------------------
# = Class: openldap::client::common
#
# Base class to be inherited by the other openldap classes
#
# Note: respect the Naming standard provided here[http://projects.puppetlabs.com/projects/puppet/wiki/Module_Standards]
class openldap::client::common {

    # Load the variables used in this module. Check the openldap-params.pp file
    require openldap::params

    package { $openldap::params::packagename_client:
        ensure => $openldap::client::ensure,
        name   => $openldap::params::packagename_client,
    }

    ## SSL

    if ($openldap::client::ssl_cacertfile_source != '') {
        if (! defined(File[$openldap::params::cert_directory])) {
            file { $openldap::params::cert_directory:
                ensure => 'directory',
                owner  => $openldap::params::configfile_client_owner,
                group  => $openldap::params::configfile_client_group,
                mode   => $openldap::params::databasedir_mode,
            }
        }

        $ssl_cacertfile = "${openldap::params::cert_directory}/ldap_cacert.pem"

        file { $ssl_cacertfile:
            ensure  => $openldap::client::ensure,
            owner   => $openldap::params::configfile_client_owner,
            group   => $openldap::params::configfile_client_group,
            mode    => $openldap::params::configfile_client_mode,
            source  => $openldap::client::ssl_cacertfile_source,
            require => File[$openldap::params::cert_directory]
        }

    }


    file { 'ldap.conf':
        ensure  => $openldap::client::ensure,
        path    => $openldap::params::configfile_client,
        owner   => $openldap::params::configfile_client_owner,
        group   => $openldap::params::configfile_client_group,
        mode    => $openldap::params::configfile_client_mode,
        content => template('openldap/ldap.conf.erb'),
        require => Package[$openldap::params::packagename_client],
    }

    if ($openldap::client::unix_auth == 'yes')
    {

        package { $openldap::params::packagename_unix_auth:
            ensure  => $openldap::client::ensure,
        }

        ## LINK ldap.conf / nss / pam

        # libnss-ldap.conf
        file {$openldap::params::configfile_nss:
            ensure => 'link',
            owner  => $openldap::params::configfile_client_owner,
            group  => $openldap::params::configfile_client_group,
            target => $openldap::params::configfile_client,
        }

        file {$openldap::params::configfile_pam:
            ensure => 'link',
            owner  => $openldap::params::configfile_client_owner,
            group  => $openldap::params::configfile_client_group,
            target => $openldap::params::configfile_client,
        }

        ## NSSWITCH

        # ugly sed commands to edit nsswitch.conf because of missing nsswitch
        # lense in augeas in Debian Squeeze :( (available in augeas 0.7.4)

        # Passwd
        exec { "sed -s -i 's/passwd:[ ]*\\(.*\\)$/passwd: \\1 ldap # edited by puppet/' /etc/nsswitch.conf":
            path   => '/usr/bin:/usr/sbin:/bin',
            unless => "grep -e '^passwd:.*ldap.*$' /etc/nsswitch.conf",
        }

        # Group
        exec { "sed -s -i 's/group:[ ]*\\(.*\\)$/group: \\1 ldap # edited by puppet/' /etc/nsswitch.conf":
            path   => '/usr/bin:/usr/sbin:/bin',
            unless => "grep -e '^group:.*ldap.*$' /etc/nsswitch.conf",
        }

        # shadow
        exec { "sed -s -i 's/shadow:[ ]*\\(.*\\)$/shadow: \\1 ldap # edited by puppet/' /etc/nsswitch.conf":
            path   => '/usr/bin:/usr/sbin:/bin',
            unless => "grep -e '^shadow:.*ldap.*$' /etc/nsswitch.conf",
        }

    }
}

