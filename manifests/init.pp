class pe_external_postgresql (
  $postgres_root_password   = 'password',
  $puppetdb_db_password     = 'password',
  $classifier_db_password   = 'password',
  $rbac_db_password         = 'password',
  $activity_db_password     = 'password',
  $orchestrator_db_password = 'password',
  $postgresql_version       = '9.4',
  $console                  = true,
  $puppetdb                 = true,
) {

  class { 'postgresql::globals':
    manage_package_repo => true,
    version             => $postgresql_version,
  } ->
  class { 'postgresql::server':
    ip_mask_deny_postgres_user => '0.0.0.0/32',
    ip_mask_allow_all_users    => '0.0.0.0/0',
    listen_addresses           => '*',
    postgres_password          => $postgres_root_password,
    encoding                   => 'utf8',
    locale                     => 'en_US.utf8',
  }

  include postgresql::server::contrib

  if $puppetdb {
    class { 'pe_external_postgresql::puppetdb':
      postgres_root_password => $postgres_root_password,
      puppetdb_db_password   => $puppetdb_db_password,
      require                => Class['pe_external_postgresql'],
    }
  }

  if $console {
    class { 'pe_external_postgresql::console':
      postgres_root_password   => $postgres_root_password,
      classifier_db_password   => $classifier_db_password,
      rbac_db_password         => $rbac_db_password,
      activity_db_password     => $activity_db_password,
      orchestrator_db_password => $orchestrator_db_password,
      require                  => Class['pe_external_postgresql'],
    }
  }
}
