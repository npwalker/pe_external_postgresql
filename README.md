Overview
--------

This puppet module will configure an external postgresql node for your Puppet Enterprise infrastructure.

Module Description
------------------

It will do the following things:
 - Install postgresql 9.2
 - Install postgresql-contrib package
 - Create databases and users that are required by PE
 - Install the citext module on the rbac databse which is required by PE
   - https://docs.puppetlabs.com/pe/latest/install_upgrading_notes.html#a-note-about-rbac-node-classifier-and-external-postgresql

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

