#!/bin/sh

echo `date`

# src directory of the mongo collections
SRC_DIR=/devext/backup/dbscripts/mongodb/mongo_collections

for directory in $SRC_DIR/*
do
	for file in $directory/*
	do
	dbname='basename $directory'
	/dev/softwares/mongodb-linux-x86_64-debian71-3.2.8/bin/mongo dev-mon-001:27017/$dbname --username devadmin --password devadmin123 --ssl --sslPEMKeyFile /devext/softwares/mongodb-a/certs/certificate.pem --sslCAFile /devext/softwares/mongodb-a/certs/certificate.pem --sslPEMKeyPassword changeit --sslAllowInvalidHostnames --sslAllowInvalidCertificates < $file
	done
done
