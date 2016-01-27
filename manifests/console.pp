class pe_external_postgresql::console (
  $postgres_root_password   = 'password',
  $classifier_db_password   = 'password',
  $rbac_db_password         = 'password',
  $activity_db_password     = 'password',
  $orchestrator_db_password = 'password',
) {

  # Classifier database
  postgresql::server::role { 'pe-classifier':
    password_hash => postgresql_password('pe-classifier', $classifier_db_password ),
  }

  postgresql::server::db { 'pe-classifier':
    user     => 'pe-classifier',
    password => postgresql_password('pe-classifier', $classifier_db_password ),
  }

  postgresql::server::extension { 'pe-classifier-pgstattuple':
    ensure    => present,
    extension => 'pgstattuple',
    database  => 'pe-classifier',
    require   => Postgresql::Server::Db['pe-classifier'],
  }

  # RBAC Database
  postgresql::server::role { 'pe-rbac':
    password_hash => postgresql_password('pe-rbac', $rbac_db_password ),
  }

  postgresql::server::db { 'pe-rbac':
    user     => 'pe-rbac',
    password => postgresql_password('pe-rbac', $rbac_db_password ),
  }

  postgresql::server::extension { 'pe-rbac-citext':
    ensure    => present,
    extension => 'citext',
    database  => 'pe-rbac',
    require   => Postgresql::Server::Db['pe-rbac'],
  }

  # Activity service database
  postgresql::server::role { 'pe-activity':
    password_hash => postgresql_password('pe-activity', $activity_db_password ),
  }

  postgresql::server::db { 'pe-activity':
    user     => 'pe-activity',
    password => postgresql_password('pe-activity', $activity_db_password ),
  }

}
