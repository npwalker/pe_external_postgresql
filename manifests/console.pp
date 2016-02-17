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

  postgresql::server::tablespace { 'pe-classifier':
    location => "${postgresql::globals::datadir}/pe-classifier",
    require  => Class['postgresql::server'],
  }

  postgresql::server::db { 'pe-classifier':
    user       => 'pe-classifier',
    password   => postgresql_password('pe-classifier', $classifier_db_password ),
    tablespace => 'pe-classifier',
    require    => Postgresql::Server::Tablespace['pe-classifier'],
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

  postgresql::server::tablespace { 'pe-rbac':
    location => "${postgresql::globals::datadir}/pe-rbac",
    require  => Class['postgresql::server'],
  }

  postgresql::server::db { 'pe-rbac':
    user       => 'pe-rbac',
    password   => postgresql_password('pe-rbac', $rbac_db_password ),
    tablespace => 'pe-rbac',
    require    => Postgresql::Server::Tablespace['pe-rbac'],
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

  postgresql::server::tablespace { 'pe-activity':
    location => "${postgresql::globals::datadir}/pe-activity",
    require  => Class['postgresql::server'],
  }

  postgresql::server::db { 'pe-activity':
    user       => 'pe-activity',
    password   => postgresql_password('pe-activity', $activity_db_password ),
    tablespace => 'pe-activity',
    require    => Postgresql::Server::Tablespace['pe-activity'],
  }

  # Orchestrator database
  postgresql::server::role { 'pe-orchestrator':
    password_hash => postgresql_password('pe-orchestrator', $orchestrator_db_password ),
  }

  postgresql::server::tablespace { 'pe-orchestrator':
    location => "${postgresql::globals::datadir}/pe-orchestrator",
    require  => Class['postgresql::server'],
  }

  postgresql::server::db { 'pe-orchestrator':
    user       => 'pe-orchestrator',
    password   => postgresql_password('pe-orchestrator', $orchestrator_db_password ),
    tablespace => 'pe-orchestrator',
    require    => Postgresql::Server::Tablespace['pe-orchestrator'],
  }

}
