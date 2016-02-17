# The baseline for module testing used by Puppet Labs is that each manifest
# should have a corresponding test manifest that declares that class or defined
# type.
#
# Tests are then run by using puppet apply --noop (to check for compilation
# errors and view a log of events) or by fully applying the test in a virtual
# environment (to compare the resulting system state to the desired state).
#
# Learn more about module testing here:
# http://docs.puppetlabs.com/guides/tests_smoke.html
#
#
#
# You can execute this manifest as follows in your vagrant box:
#
#      sudo puppet apply -t /vagrant/tests/init.pp
#
node default {
    class { 'openldap::server':
        use_ssl   => 'yes',
        db_name   => 'uni.lu',
        suffix    => 'dc=uni,dc=lu',
        admin_dn  => 'cn=admin,dc=uni,dc=lu',
        admin_pwd => '********************',
        salt      => 'r4nd0m',
    }

    openldap::server::acl { 'password and ssh public key':
        what      => 'attrs="userPassword,shadowLastChange,sshPublicKey"',
        who       => {
                        'cn=admin,dc=uni,dc=lu' => 'write',
                        'self'                  => 'write'
                    },
        anonymous => 'no',
        order     => 1
    }
    openldap::server::acl { 'personnal data':
        what      => 'attrs="loginShell,jpegPhoto,mail,telephoneNumber"',
        who       => {
                        'cn=admin,dc=uni,dc=lu' => 'write',
                        'self'                  => 'write'
                    },
        anonymous => 'yes',
        order     => 2
    }
    openldap::server::acl { 'entire tree':
        what      => '*',
        who       => {
                        'cn=admin,dc=uni,dc=lu' => 'write'
                    },
        anonymous => 'yes',
        order     => 3
    }

    openldap::server::ou::entry { 'ou=People,dc=uni,dc=lu':
        ou   => 'People',
        desc => 'Branch which includes all the users',
    }
    openldap::server::ou::entry { 'ou=Groups,dc=uni,dc=lu':
        ou   => 'Groups',
        desc => 'Branch which includes all the groups',
    }

}
