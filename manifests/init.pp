class pe_external_postgresql (
  $postgres_root_password = 'password',
  $puppetdb_db_password   = 'password',
  $classifier_db_password = 'password',
  $rbac_db_password       = 'password',
  $activity_db_password   = 'password',
  $postgresql_version     = '9.2',
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

  postgresql::server::role { 'pe-puppetdb':
    password_hash => postgresql_password('pe-puppetdb', $puppetdb_db_password ),
  }

  postgresql::server::db { 'pe-puppetdb':
    user     => 'pe-puppetdb',
    password => postgresql_password('pe-puppetdb', $puppetdb_db_password ),
  }

  $pg_trgm_cmd = 'CREATE EXTENSION pg_trgm;'
  postgresql_psql { $pg_trgm_cmd:
    db      => 'pe-puppetdb',
    unless  => "select * from pg_extension where extname='pg_trgm'",
    require => Postgresql::Server::Db['pe-puppetdb'],
  }

  postgresql::server::role { 'pe-classifier':
    password_hash => postgresql_password('pe-classifier', $classifier_db_password ),
  }

  postgresql::server::db { 'pe-classifier':
    user     => 'pe-classifier',
    password => postgresql_password('pe-classifier', $classifier_db_password ),
  }

  postgresql::server::role { 'pe-rbac':
    password_hash => postgresql_password('pe-rbac', $rbac_db_password ),
  }

  postgresql::server::db { 'pe-rbac':
    user     => 'pe-rbac',
    password => postgresql_password('pe-rbac', $rbac_db_password ),
  }

  $citext_cmd = 'CREATE EXTENSION citext;'
  postgresql_psql { $citext_cmd:
    db      => 'pe-rbac',
    unless  => "select * from pg_extension where extname='citext'",
    require => Postgresql::Server::Db['pe-rbac'],
  }

  postgresql::server::role { 'pe-activity':
    password_hash => postgresql_password('pe-activity', $activity_db_password ),
  }

  postgresql::server::db { 'pe-activity':
    user     => 'pe-activity',
    password => postgresql_password('pe-activity', $activity_db_password ),
  }

}
