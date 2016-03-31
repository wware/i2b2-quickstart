create user i2b2demodata with password 'demouser';
grant all privileges on all tables in all tables in schema  public to i2b2demodata;
 
create user i2b2hive with password  'demouser';
grant all privileges on all tables in  schema  i2b2hive to i2b2hive; 

create user i2b2imdata with password  'demouser';
#grant all privileges on all tables in  schema  i2b2imdata to i2b2imdata; 

create user i2b2metadata with password  'demouser';
grant all privileges on all tables in  schema  public to i2b2metadata; 

create user i2b2pm with password  'demouser';
#grant all privileges on all tables in  schema  i2b2pm to i2b2pm; 

create user i2b2workdata with password  'demouser';
#grant all privileges on all tables in  schema  public to i2b2workdata; 

