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
    class { 'openldap::client':
        ensure      => 'present',
        base        => 'dc=uni,dc=lu',
        uri         => 'ldap://localhost:389',
        use_ssl     => 'yes',
        unix_auth   => 'yes',
        base_passwd => 'ou=People,ou=Gaia,ou=Cluster,ou=HPC,ou=Services,dc=uni,dc=lu',
        base_group  => 'ou=Groups,ou=Gaia,ou=Cluster,ou=HPC,ou=Services,dc=uni,dc=lu',
        scope       => 'sub'
    }
}
