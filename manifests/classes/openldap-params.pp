# File::      <tt>openldap-params.pp</tt>
# Author::    Hyacinthe Cartiaux (hyacinthe.cartiaux@uni.lu)
# Copyright:: Copyright (c) 2011 Hyacinthe Cartiaux
# License::   GPL v3
#
# ------------------------------------------------------------------------------
# = Class: openldap::params
#
# In this class are defined as variables values that are used in other
# openldap classes.
# This class should be included, where necessary, and eventually be enhanced
# with support for more OS
#
# == Warnings
#
# /!\ Always respect the style guide available
# here[http://docs.puppetlabs.com/guides/style_guide]
#
# The usage of a dedicated param classe is advised to better deal with
# parametrized classes, see
# http://docs.puppetlabs.com/guides/parameterized_classes.html
#
# [Remember: No empty lines between comments and class definition]
#
class openldap::params {

    ######## DEFAULTS FOR VARIABLES USERS CAN SET ##########################
    # (Here are set the defaults, provide your custom variables externally)
    # (The default used is in the line with '')
    ###########################################

    # ensure the presence (or absence) of openldap
    $ensure = $openldap_ensure ? {
        ''      => 'present',
        default => "${openldap_ensure}"
    }

    $ssl = $openldap_ssl ? {
        ''      => 'yes',
        default => "${openldap_ssl}"
    }

    $dbname = $openldap_name ? {
        ''      => 'uni.lu',
        default => "${openldap_name}"
    }

    $suffix = $openldap_suffix ? {
        ''      => 'dc=uni,dc=lu',
        default => "${openldap_suffix}"
    }

    $admin_dn = $openldap_admin_dn ? {
        ''      => 'cn=admin,dc=uni,dc=lu',
        default => "${openldap_admin_dn}"
    }

    $admin_pwd = $openldap_admin_pwd ? {
        ''      => '/!\\ DEFAULT PASSWORD /!\\',
        default => "${openldap_admin_pwd}"
    }

    $syncprov = $openldap_syncprov ? {
        ''      => 'no',
        default => "${openldap_syncprov}"
    }

    $uri = $openldap_uri ? {
        ''      => 'ldap://localhost/',
        default => "${openldap_uri}",
    }
    # The Protocol used. Used by monitor and firewall class. Default is 'tcp'
    $protocol = $openldap_protocol ? {
        ''      => 'tcp',
        default => "${openldap_protocol}",
    }
    # The port number. Used by monitor and firewall class. The default is 22.
    $port = $openldap_port ? {
        ''      => 389,
        default => "${openldap_port}",
    }

    $modules = $openldap_modules ? {
        ''      => ['back_ldap', 'back_bdb', 'syncprov'],
        default => $openldap_modules,
    }

    $unix_auth = $openldap_unix_auth ? {
        ''      => 'no',
        default => $openldap_unix_auth,
    }

    $base_passwd = $openldap_base_passwd ? {
        ''      => "ou=People,${suffix}",
        default => $openldap_base_passwd,
    }

    $base_group = $openldap_base_group ? {
        ''      => "ou=Groups,${suffix}",
        default => $openldap_base_group,
    }

    $scope = $openldap_scope ? {
        ''      => "one",
        default => $openldap_scope,
    }

    $default_db = $::operatingsystem ? {
        /(?i-mx:ubuntu|debian)/ => '1', # 0 is config, 1 is first user db
        default                 => '1', # to test ?
    }

    # Default salt value for slappasswd #
    $salt = "!CHANGEIT!"

    $cert_directory = "/etc/ssl/slapd"

    #### MODULE INTERNAL VARIABLES  #########
    # (Modify to adapt to unsupported OSes)
    #######################################
    $packagename_server = $::operatingsystem ? {
        /(?i-mx:ubuntu|debian)/ => 'slapd',
        default                 => 'openldap',
    }

    $packagename_client = $::operatingsystem ? {
        /(?i-mx:ubuntu|debian)/ => 'ldap-utils',
        default                 => 'ldap-utils',
    }

    $packagename_unix_auth = $::operatingsystem ? {
        /(?i-mx:ubuntu|debian)/ => ['libnss-ldap',
                                    'libpam-ldap'],
        default                 => [],
    }

    $servicename = $::operatingsystem ? {
        /(?i-mx:ubuntu|debian)/ => 'slapd',
        default                 => 'openldap'
    }

    # used for pattern in a service ressource
    $processname = $::operatingsystem ? {
        /(?i-mx:ubuntu|debian)/ => 'slapd',
        default                 => 'slapd',
    }

    $hasstatus = $::operatingsystem ? {
        /(?i-mx:ubuntu|debian)/        => true,
        /(?i-mx:centos|fedora|redhat)/ => true,
        default => true,
    }

    $hasrestart = $::operatingsystem ? {
        default => true,
    }


    $configfile_server = $::operatingsystem ? {
        default => '/etc/ldap/slapd.conf',
    }

    $configdir_schema = $::operatingsystem ? {
        default => '/etc/ldap/schema',
    }

    $configfile_client = $::operatingsystem ? {
        default => '/etc/ldap/ldap.conf',
    }

    $configfile_pam = $::operatingsystem ? {
        default => '/etc/pam_ldap.conf',
    }

    $configfile_nss = $::operatingsystem ? {
        default => '/etc/libnss-ldap.conf',
    }

    $ldifdir = $::operatingsystem ? {
        default => '/var/lib/ldap/puppet',
    }

    $configfile_mode = $::operatingsystem ? {
        default => '0640',
    }

    $configdir_schema_mode = $::operatingsystem ? {
        default => '0644',
    }

    $configfile_group = $::operatingsystem ? {
        default => 'openldap',
    }

    $configfile_owner = $::operatingsystem ? {
        default => 'root',
    }

    $configfile_client_mode = $::operatingsystem ? {
        default => '0644',
    }

    $configfile_client_group = $::operatingsystem ? {
        default => 'root',
    }

    $configfile_client_owner = $::operatingsystem ? {
        default => 'root',
    }

    $databasedir = $::operatingsystem ? {
        default => "/var/lib/ldap",
    }
    $databasedir_mode = $::operatingsystem ? {
        default => '0755',
    }

    $databasedir_owner = $::operatingsystem ? {
        default => 'openldap',
    }

    $databasedir_group = $::operatingsystem ? {
        default => 'openldap',
    }


}

