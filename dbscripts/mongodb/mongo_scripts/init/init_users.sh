#!/bin/sh

echo `date`

# src directory of the mongo users
SRC_DIR=/devext/backup/dbscripts/mongodb/mongo_users

for file in $SRC_DIR/*

do

/dev/softwares/mongodb-linux-x86_64-debian71-3.2.8/bin/mongo dev-mon-001:27017/admin --username sysadmin --password tranzformpwd --ssl --sslPEMKeyFile /devext/softwares/mongodb-a/certs/certificate.pem --sslCAFile /devext/softwares/mongodb-a/certs/certificate.pem --sslPEMKeyPassword changeit --sslAllowInvalidHostnames --sslAllowInvalidCertificates < $file

done