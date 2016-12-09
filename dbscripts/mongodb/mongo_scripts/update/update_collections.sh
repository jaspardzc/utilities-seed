#!/bin/sh

echo `date`

# root directory of the mongo collections
SRC_DIR=/devext/backup/dbscripts/mongodb/mongo_collections

for file in $SRC_DIR/*

do

/dev/softwares/mongodb-linux-x86_64-debian71-3.2.8/bin/mongo lcl-cnt-mon-001:27017/$1 --username devadmin --password devadmin123 --ssl --sslPEMKeyFile /devext/softwares/mongodb-a/certs/certificate.pem --sslCAFile /devext/softwares/mongodb-a/certs/certificate.pem --sslPEMKeyPassword changeit --sslAllowInvalidHostnames --sslAllowInvalidCertificates   < $file

done

