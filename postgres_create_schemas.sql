

create database i2b2;
\c i2b2;
 create schema i2b2demodata;
 create schema i2b2hive;
 create schema i2b2imdata;
 create schema i2b2metadata;
 create schema i2b2pm;
 create schema i2b2workdata;
 
create user i2b2demodata password 'demouser';
 create user i2b2hive password 'demouser';
 create user i2b2imdata password 'demouser';
 create user i2b2metadata password 'demouser';
 create user i2b2pm password 'demouser';
 create user i2b2workdata password 'demouser';
 
GRANT ALL ON SCHEMA i2b2demodata TO i2b2demodata;
 GRANT ALL ON SCHEMA i2b2hive TO i2b2hive;
 GRANT ALL ON SCHEMA i2b2imdata TO i2b2imdata;
 GRANT ALL ON SCHEMA i2b2metadata TO i2b2metadata;
 GRANT ALL ON SCHEMA i2b2pm TO i2b2pm;
 GRANT ALL ON SCHEMA i2b2workdata TO i2b2workdata;
 
GRANT ALL ON ALL TABLES IN SCHEMA i2b2demodata TO i2b2demodata;
 GRANT ALL ON ALL TABLES IN SCHEMA i2b2hive TO i2b2hive;
 GRANT ALL ON ALL TABLES IN SCHEMA i2b2imdata TO i2b2imdata;
 GRANT ALL ON ALL TABLES IN SCHEMA i2b2metadata TO i2b2metadata;
 GRANT ALL ON ALL TABLES IN SCHEMA i2b2pm TO i2b2pm;
 GRANT ALL ON ALL TABLES IN SCHEMA i2b2workdata TO i2b2workdata;



