name       'openldap'
version    '0.0.2'
source     'git-admin.uni.lu:puppet-repo.git'
author     'Hyacinthe Cartiaux (hyacinthe.cartiaux@uni.lu)'
license    'GPL v3'
summary    'Configure and manage openldap'
description 'Configure and manage openldap'
project_page 'UNKNOWN'

## List of the classes defined in this module
classes    'openldap::server, openldap::server::common, openldap::server::debian, openldap::server::redhat, openldap::client, openldap::client::common, openldap::client::debian, openldap::client::redhat, openldap::params'

## Add dependencies, if any:
# dependency 'username/name', '>= 1.2.0'
dependency 'concat'
dependency 'openssl'
defines    '["openldap::server::sync", "openldap::server::ou", "openldap::server::slapadd", "openldap::server::admin", "openldap::server::root", "openldap::server::overlay", "openldap::server::database", "openldap::server::acl"]'
