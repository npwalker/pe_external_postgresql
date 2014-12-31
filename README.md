This puppet module will configure an external postgresql node for your Puppet Enterprise infrastructure.

It will do the following things:
 - Install postgresql 9.2
 - Install postgresql-contrib package
 - Create databases and users that are required by PE
 - Install the citext module on the rbac databse which is required by PE
   - https://docs.puppetlabs.com/pe/latest/install_upgrading_notes.html#a-note-about-rbac-node-classifier-and-external-postgresql
 
Currently you can configure passwords for each of the users via paramter. 

Example Usage:
 
```
class { 'pe_external_postgresql' :
  postgres_root_password  => 'pass1',
  puppetdb_db_password    => 'pass2',
  console_db_password     => 'pass3',
  classifier_db_password  => 'pass4',
  rbac_db_password        => 'pass5',
  activity_db_password    => 'pass6',
}
```

In order to effectively use this module you will need to do the following in the context of installing PE.

1. Install the PE agent on the node you want to make your external postgresql node
 - If you are installing a split installation you can install the puppet master node before installing this agent
 - If you are installing an all-in-one master you will need to install this agent and continue when it says it can't connect to the master
2. Save the above class declaration to a file on your agent node and modify to your needs
3. Run `puppet apply /path/to/file` on the agent node to install postgresql and setup the databases. 

 
