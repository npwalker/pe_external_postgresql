class pe_external_postgresql (
  $postgres_root_password   = 'password',
  $puppetdb_db_password     = 'password',
  $classifier_db_password   = 'password',
  $rbac_db_password         = 'password',
  $activity_db_password     = 'password',
  $orchestrator_db_password = 'password',
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

  # PuppetDB Database
  postgresql::server::db { 'pe-puppetdb':
    user     => 'pe-puppetdb',
    password => postgresql_password('pe-puppetdb', $puppetdb_db_password ),
  }

  postgresql::server::extension { 'pe-puppetdb-pg_trgm':
    ensure    => present,
    extension => 'pg_trgm',
    db        => 'pe-puppetdb',
    require   => Postgresql::Server::Db['pe-puppetdb'],
  }

  postgresql::server::extension { 'pe-puppetdb-pgstattuple':
    ensure    => present,
    extension => 'pgstattuple',
    db        => 'pe-puppetdb',
    require   => Postgresql::Server::Db['pe-puppetdb'],
  }


  # Classifier database
  postgresql::server::db { 'pe-classifier':
    user     => 'pe-classifier',
    password => postgresql_password('pe-classifier', $classifier_db_password ),
  }

  postgresql::server::extension { 'pe-classifier-pgstattuple':
    ensure    => present,
    extension => 'pgstattuple',
    db        => 'pe-classifier',
    require   => Postgresql::Server::Db['pe-classifier'],
  }

  # RBAC Database
  postgresql::server::db { 'pe-rbac':
    user     => 'pe-rbac',
    password => postgresql_password('pe-rbac', $rbac_db_password ),
  }

  postgresql::server::extension { 'pe-rbac-citext':
    ensure    => present,
    extension => 'citext',
    db        => 'pe-rbac',
    require   => Postgresql::Server::Db['pe-rbac'],
  }

  # Activity service database
  postgresql::server::db { 'pe-activity':
    user     => 'pe-activity',
    password => postgresql_password('pe-activity', $activity_db_password ),
  }

}
