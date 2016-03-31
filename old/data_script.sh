cd data/edu.harvard.i2b2.data/Release_1-7/NewInstall/

cd Crcdata
ant create_crcdata_tables_release_1-7
ant db_demodata_load_data

cd Hivedata
ant create_hivedata_tables_release_1-7
ant db_hivedata_load_data

cd Imdata
ant create_imdata_tables_release_1-7
ant db_imdata_load_data

cd Metadata
ant create_metadata_tables_release_1-7
ant db_metadata_load_data

cd Pmdata
ant create_pmdata_tables_release_1-7
ant create_triggers_release_1-7
ant db_pmdata_load_data

cd Workdata
ant create_workdata_tables_release_1-7
ant db_workdata_load_data
