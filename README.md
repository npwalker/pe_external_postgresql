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
