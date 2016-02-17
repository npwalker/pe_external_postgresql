class pe_external_postgresql::puppetdb (
  $postgres_root_password   = 'password',
  $puppetdb_db_password     = 'password',
) {

  # PuppetDB Database
  postgresql::server::role { 'pe-puppetdb':
    password_hash => postgresql_password('pe-puppetdb', $puppetdb_db_password ),
  }

  postgresql::server::tablespace { 'pe-puppetdb':
    location => "${::postgresql::globals::datadir}/pe-puppetdb",
    require  => Class['postgresql::server'],
  }

  postgresql::server::db { 'pe-puppetdb':
    user       => 'pe-puppetdb',
    tablespace => 'pe-puppetdb',
    password   => postgresql_password('pe-puppetdb', $puppetdb_db_password ),
    require    => Postgresql::Server::Tablespace['pe-puppetdb'],
  }

  postgresql::server::extension { 'pe-puppetdb-pg_trgm':
    ensure    => present,
    extension => 'pg_trgm',
    database  => 'pe-puppetdb',
    require   => Postgresql::Server::Db['pe-puppetdb'],
  }

  postgresql::server::extension { 'pe-puppetdb-pgstattuple':
    ensure    => present,
    extension => 'pgstattuple',
    database  => 'pe-puppetdb',
    require   => Postgresql::Server::Db['pe-puppetdb'],
  }
}
