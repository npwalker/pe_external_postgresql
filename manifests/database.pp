define pe_external_postgresql::database (
  String                  $db_name     = $title,
  String                  $db_password = 'password',
  Optional[Array[String]] $extensions  = undef,
) {

  postgresql::server::role { $db_name :
    password_hash => postgresql_password( $db_name, $db_password ),
  }

  postgresql::server::role { "${db_name}-write" :
    password_hash => postgresql_password( $db_name, $db_password ),
  }

  postgresql::server::tablespace { $db_name :
    location => "${::postgresql::globals::datadir}/${db_name}",
  }

  postgresql::server::db { $db_name :
    user       => $db_name,
    tablespace => $db_name,
    password   => postgresql_password( $db_name, $db_password ),
    require    => [ Postgresql::Server::Role[$db_name], Postgresql::Server::Tablespace[$db_name] ],
  }

  if !empty( $extensions ) {
    $extensions.each | String $extension | {
      postgresql::server::extension { "${db_name}-${extension}":
        ensure    => present,
        extension => $extension,
        database  => $db_name,
        require   => Postgresql::Server::Db[$db_name],
      }
    }
  }
}
