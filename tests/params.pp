# File::      <tt>params.pp</tt>
# Author::    S. Varrette, H. Cartiaux, V. Plugaru, S. Diehl aka. UL HPC Management Team (hpc-sysadmins@uni.lu)
# Copyright:: Copyright (c) 2016 S. Varrette, H. Cartiaux, V. Plugaru, S. Diehl aka. UL HPC Management Team
# License::   Gpl-3.0
#
# ------------------------------------------------------------------------------
# You need the 'future' parser to be able to execute this manifest (that's
# required for the each loop below).
#
# Thus execute this manifest in your vagrant box as follows:
#
#      sudo puppet apply -t --parser future /vagrant/tests/params.pp
#
#

include 'openldap::params'

$names = ['ensure', 'ssl', 'dbname', 'suffix', 'admin_create', 'admin_dn', 'admin_pwd', 'syncprov', 'memberof', 'uri', 'protocol', 'port', 'modules', 'unix_auth', 'base_passwd', 'base_group', 'scope', 'default_db', 'salt', 'cert_directory', 'packagename_server', 'packagename_client', 'packagename_unix_auth', 'servicename', 'processname', 'hasstatus', 'hasrestart', 'configfile_server', 'configdir_schema', 'configfile_client', 'configfile_client_alternate', 'configfile_pam', 'configfile_nss', 'ldifdir', 'configfile_mode', 'configdir_schema_mode', 'configfile_group', 'configfile_owner', 'configfile_client_mode', 'configfile_client_group', 'configfile_client_owner', 'databasedir', 'databasedir_mode', 'databasedir_owner', 'databasedir_group']

notice("openldap::params::ensure = ${openldap::params::ensure}")
notice("openldap::params::ssl = ${openldap::params::ssl}")
notice("openldap::params::dbname = ${openldap::params::dbname}")
notice("openldap::params::suffix = ${openldap::params::suffix}")
notice("openldap::params::admin_create = ${openldap::params::admin_create}")
notice("openldap::params::admin_dn = ${openldap::params::admin_dn}")
notice("openldap::params::admin_pwd = ${openldap::params::admin_pwd}")
notice("openldap::params::syncprov = ${openldap::params::syncprov}")
notice("openldap::params::memberof = ${openldap::params::memberof}")
notice("openldap::params::uri = ${openldap::params::uri}")
notice("openldap::params::protocol = ${openldap::params::protocol}")
notice("openldap::params::port = ${openldap::params::port}")
notice("openldap::params::modules = ${openldap::params::modules}")
notice("openldap::params::unix_auth = ${openldap::params::unix_auth}")
notice("openldap::params::base_passwd = ${openldap::params::base_passwd}")
notice("openldap::params::base_group = ${openldap::params::base_group}")
notice("openldap::params::scope = ${openldap::params::scope}")
notice("openldap::params::default_db = ${openldap::params::default_db}")
notice("openldap::params::salt = ${openldap::params::salt}")
notice("openldap::params::cert_directory = ${openldap::params::cert_directory}")
notice("openldap::params::packagename_server = ${openldap::params::packagename_server}")
notice("openldap::params::packagename_client = ${openldap::params::packagename_client}")
notice("openldap::params::packagename_unix_auth = ${openldap::params::packagename_unix_auth}")
notice("openldap::params::servicename = ${openldap::params::servicename}")
notice("openldap::params::processname = ${openldap::params::processname}")
notice("openldap::params::hasstatus = ${openldap::params::hasstatus}")
notice("openldap::params::hasrestart = ${openldap::params::hasrestart}")
notice("openldap::params::configfile_server = ${openldap::params::configfile_server}")
notice("openldap::params::configdir_schema = ${openldap::params::configdir_schema}")
notice("openldap::params::configfile_client = ${openldap::params::configfile_client}")
notice("openldap::params::configfile_client_alternate = ${openldap::params::configfile_client_alternate}")
notice("openldap::params::configfile_pam = ${openldap::params::configfile_pam}")
notice("openldap::params::configfile_nss = ${openldap::params::configfile_nss}")
notice("openldap::params::ldifdir = ${openldap::params::ldifdir}")
notice("openldap::params::configfile_mode = ${openldap::params::configfile_mode}")
notice("openldap::params::configdir_schema_mode = ${openldap::params::configdir_schema_mode}")
notice("openldap::params::configfile_group = ${openldap::params::configfile_group}")
notice("openldap::params::configfile_owner = ${openldap::params::configfile_owner}")
notice("openldap::params::configfile_client_mode = ${openldap::params::configfile_client_mode}")
notice("openldap::params::configfile_client_group = ${openldap::params::configfile_client_group}")
notice("openldap::params::configfile_client_owner = ${openldap::params::configfile_client_owner}")
notice("openldap::params::databasedir = ${openldap::params::databasedir}")
notice("openldap::params::databasedir_mode = ${openldap::params::databasedir_mode}")
notice("openldap::params::databasedir_owner = ${openldap::params::databasedir_owner}")
notice("openldap::params::databasedir_group = ${openldap::params::databasedir_group}")

#each($names) |$v| {
#    $var = "openldap::params::${v}"
#    notice("${var} = ", inline_template('<%= scope.lookupvar(@var) %>'))
#}
