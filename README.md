Overview
--------

This puppet module will configure an external postgresql node for your Puppet Enterprise infrastructure.

Module Description
------------------

It will do the following things:
 - Install postgresql 9.4
 - Install postgresql-contrib package
 - Create databases and users that are required by PE
 - Install the citext module on the rbac databse which is required by PE
   - https://docs.puppetlabs.com/pe/latest/install_upgrading_notes.html#a-note-about-rbac-node-classifier-and-external-postgresql
 - Install the pgcrypto extension on the puppetdb

Example Usage
------------

In order to effectively use this module you will need to do the following in the context of installing PE.

1. Install the PE agent on the node you want to make your external postgresql node
 - If you are installing a split installation you can install the puppet master node before installing this agent
 - If you are installing an all-in-one master you will need to install this agent and continue when it says it can't connect to the master
2. Save something like the following to a file (maybe `/tmp/postgresql_setup.pp`) on your agent node but specify your own passwords
 - 
		
			class { 'pe_external_postgresql' :
			  postgres_root_password   => 'pass1',
			  puppetdb_db_password     => 'pass2',
			  classifier_db_password   => 'pass3',
			  rbac_db_password         => 'pass4',
			  activity_db_password     => 'pass5',
			  orchestrator_db_password => 'pass6',
			}
		

3. `puppet module install npwalker-pe_external_postgresql`
4. Run `puppet apply /tmp/postgresql_setup.pp` on the agent node to install postgresql and setup the databases.

###Class: pe_external_postgresql

####`postgres_root_password`
Sets the password for the postgres user.

####`puppetdb_db_password`
Sets the password for the puppetdb user to connect to the puppetdb database 

####`console_db_password`
Sets the password for the console user to connect to the console database

####`classifier_db_password`
Sets the password for the pe-classifier user to connect to the pe-classifier database

####`rbac_db_password`
Sets the password for the pe-rbac user to connect to the pe-rbac database

####`activity_db_password`
Sets the password for the pe-activity user to connect to the pe-activity database

####`orchestrator_db_password`
Sets the password for the pe-orchestrator user to connect to the pe-orchestrator database

####`postgresql_version`
The version of postgresql to install.  Defaults to 9.4.

####`max_connections`
The amount of client connections PSQL will allow. Defaults to 200.

####`use_pe_packages`
If set to `true`, PostgreSQL will be installed using the Puppet Enterprise
packages and paths. Note that for this option to work, you must have the
pe-postgresql and pe-postgresql-contrib packages available in the configured
machine's package repositories. Typically agent machines will have access to
these packages through the `pe_repo` class. Defaults to `false`.

###`console`
Whether or not to manage the PE console databases. If set to `false`, the
`pe-activity`, `pe-classifier`, and `pe-rbac` databases will
not be managed. This is useful when installing the Console and PuppetDB
databases on separate servers. Defaults to `true`.

###`puppetdb`
Whether or not to manage the PE PuppetDB database. If set to `false`, the
`pe-puppetdb` database will not be managed. This is useful when installing the
Console and PuppetDB databases on separate servers. Defaults to `true`.

###`orchestrator`
Whether or not to manage the PE Orchestrator database. If set to `false`, the
`pe-orchestrator` database will not be managed. I would expect users to place
this database with the console database but want to leave the option to put it
somewhere else.  Defaults to `true`.

PE3.x
------

If you are using PE3.x please use version 1.1.1 of the module which is compatible
with older versions of PE.
