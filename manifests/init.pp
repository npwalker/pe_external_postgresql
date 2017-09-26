class pe_external_postgresql (
  String  $postgres_root_password   = 'password',
  String  $puppetdb_db_password     = 'password',
  String  $classifier_db_password   = 'password',
  String  $rbac_db_password         = 'password',
  String  $activity_db_password     = 'password',
  String  $orchestrator_db_password = 'password',
  Optional[String] $postgresql_version = undef,
  Boolean $use_pe_packages          = false,
  Boolean $console                  = true,
  Boolean $puppetdb                 = true,
  Boolean $orchestrator             = true,
) {

  if $postgresql_version == undef {
    $_postgresql_version = '9.6'
  } elsif versioncmp( facts['pe_server_version'], '2017.3.0' ) >= 0 {
    $_postgresql_version = pick($postgresql_version, '9.6')
  } else {
    $_postgresql_version = pick($postgresql_version, '9.4')
  }

  if $use_pe_packages {
    $bindir               = '/opt/puppetlabs/server/bin'
    $pgsql_dir            = '/opt/puppetlabs/server/data/postgresql'
    $client_package_name  = 'pe-postgresql'
    $server_package_name  = 'pe-postgresql-server'
    $contrib_package_name = 'pe-postgresql-contrib'
    $default_database     = 'pe-postgres'
    $user                 = 'pe-postgres'
    $group                = 'pe-postgres'
    $service_name         = 'pe-postgresql'
    $datadir              = "${pgsql_dir}/${postgresql_version}/data"
    $confdir              = "${pgsql_dir}/${postgresql_version}/data"
    $psql_path            = "${bindir}/psql"
    $manage_package_repo  = false
  } else {
    $bindir               = undef
    $pgsql_dir            = undef
    $client_package_name  = undef
    $server_package_name  = undef
    $contrib_package_name = undef
    $default_database     = undef
    $user                 = undef
    $group                = undef
    $service_name         = undef
    $datadir              = undef
    $confdir              = undef
    $psql_path            = undef
    $manage_package_repo  = true 
  }

  class { '::postgresql::globals':
    version              => $_postgresql_version,
    bindir               => $bindir,
    client_package_name  => $client_package_name,
    server_package_name  => $server_package_name,
    contrib_package_name => $contrib_package_name,
    default_database     => $default_database,
    user                 => $user,
    group                => $group,
    service_name         => $service_name,
    datadir              => $datadir,
    confdir              => $confdir,
    psql_path            => $psql_path,
    manage_package_repo  => $manage_package_repo,
  } ->
  class { '::postgresql::server':
    ip_mask_deny_postgres_user => '0.0.0.0/32',
    ip_mask_allow_all_users    => '0.0.0.0/0',
    listen_addresses           => '*',
    postgres_password          => $postgres_root_password,
    encoding                   => 'utf8',
    locale                     => 'en_US.utf8',
  }

  include postgresql::server::contrib

  if $puppetdb {
    # PuppetDB Database
    pe_external_postgresql::database { 'pe-puppetdb':
      db_password => $puppetdb_db_password,
      extensions  => [ 'pg_trgm', 'pgcrypto' ],
    }
  }

  if $console {
    #Classifier database
    pe_external_postgresql::database { 'pe-classifier':
      db_password => $classifier_db_password,
    }

    # RBAC Database
    pe_external_postgresql::database { 'pe-rbac':
      db_password => $rbac_db_password,
      extensions  => [ 'citext', 'pgcrypto'],
    }

    # Activity service database
    pe_external_postgresql::database { 'pe-activity':
      db_password => $activity_db_password,
    }
  }

  if $orchestrator {
    # Orchestrator database
    pe_external_postgresql::database { 'pe-orchestrator':
      db_password => $orchestrator_db_password,
    }
  }
}
