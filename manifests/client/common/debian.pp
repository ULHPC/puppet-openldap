# File::      <tt>client/common/debian.pp</tt>
# Author::    S. Varrette, H. Cartiaux, V. Plugaru, S. Diehl aka. UL HPC Management Team (hpc-sysadmins@uni.lu)
# Copyright:: Copyright (c) 2016 S. Varrette, H. Cartiaux, V. Plugaru, S. Diehl aka. UL HPC Management Team
# License::   Gpl-3.0
#
# Specialization class for Debian systems
# ------------------------------------------------------------------------------
# = Class: openldap::client::common::debian
#
# Specialization class for Debian systems
class openldap::client::common::debian inherits openldap::client::common {

    ## PAM
    # /!\ Debian squeeze : pam configuration files are edited during package installation

    # use_authtok option prevent password changing with passwd
    augeas { 'delete use_authtok option':
        context => '/files/etc/pam.d/common-password/*[type = "password"][module = "pam_ldap.so"]',
        changes => [
            'rm argument[1]',
        ],
        onlyif  => 'get argument[1] == "use_authtok"',
    }
}
