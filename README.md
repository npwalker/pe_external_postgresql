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
 - Install the pgstattuple extension on puppetdb and classifer databases

Example Usage
------------

In order to effectively use this module you will need to do the following in the context of installing PE.

1. Install the PE agent on the node you want to make your external postgresql node
 - If you are installing a split installation you can install the puppet master node before installing this agent
 - If you are installing an all-in-one master you will need to install this agent and continue when it says it can't connect to the master
2. Save something like the following to a file (maybe `/tmp/postgresql_setup.pp`) on your agent node but specify your own passwords
 - 
		
			class { 'pe_external_postgresql' :
			  postgres_root_password  => 'pass1',
			  puppetdb_db_password    => 'pass2',
			  console_db_password     => 'pass3',
			  classifier_db_password  => 'pass4',
			  rbac_db_password        => 'pass5',
			  activity_db_password    => 'pass6',
			}
		

3. `/opt/puppet/bin/puppet module install npwalker-pe_external_postgresql`
4. Run `/opt/puppet/bin/puppet apply /tmp/postgresql_setup.pp` on the agent node to install postgresql and setup the databases.

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

####`use_pe_packages`
If set to `true`, PostgreSQL will be installed using the Puppet Enterprise
packages and paths. Note that for this option to work, you must have the
pe-postgresql and pe-postgresql-contrib packages available in the configured
machine's package repositories. Typically agent machines will have access to
these packages through the `pe_repo` class. Defaults to `false`.

###`console`
Whether or not to manage the PE console databases. If set to `false`, the
`pe-activity`, `pe-classifier`, `pe-rbac`, and `pe-orchestrator` databases will
not be managed. This is useful when installing the Console and PuppetDB
databases on separate servers. Defaults to `true`.

###`puppetdb`
Whether or not to manage the PE PuppetDB database. If set to `false`, the
`pe-puppetdb` database will not be managed. This is useful when installing the
Console and PuppetDB databases on separate servers. Defaults to `true`.

