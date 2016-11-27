About this directory
====================
This directory will give a brief specification on SSL handshake flow, concepts of private and public keys, and a list of useful commands of `openssl`

SSL Basic Concepts
------------------
- common handshake flow
    1. client send a a secure session request
    2. server send the x.509 certificate and the server's public key
    3. client authenticate certificate against a list of known CAs, if CA is unkown, browser/client give user option to accept certificate 
        at user's risk
    4. client generate random symmetric private key and encrypts it using server's public key, send encrypted private key back to server
    5. sever decrypt the encrypted private key using server's private key, get the client's private key
    6. now the secure session started between cient and server

- key file
    1. the KEY extension is used both for public and private keys. the keys may be encoded as binary DER or as ASCII PEM.

- crt file
    1. the CRT extension is used for certificates. The certificates may be encoded as binary DER or as ASCII PEM. 
    2. the returned , signed, x509 certificate

- der file (for encodings)
    1. the DER extension is used for binary DER encoded certificates.
    
- pem file (for encodings)
    1. files which contain ASCII (Base64) armored data prefixed with a ==== BEGIN ==== line.


SSL Common Commands
------------------
- x509 arg
this option outputs a self signed certificate instead of a certificate request. This is typically used to generate a test certificate or a self signed root CA.

- req arg
this option generates a certificate request

- nodes arg
- this option disable the encryption and the private key created

- newkey arg
this option generates a new key and a new certificate request

- days arg(number)
the valid time period for certificates, default is 30 days

- a useful command for simple certificate and private key generation
~$ openssl req -newkey -nodes -x509 arg -keyout filename 

- view PEM encoded certificate
~$ openssl x509 -in cert.pem -text -noout
~$ openssl x509 -in cert.cer -text -noout
~$ openssl x509 -in cert.crt -text -noout

- view DER encoded certificate
~$ openssl x509 -in certificate.der -inform der -text -noout

- PEM to DER
~$ openssl x509 -in cert.crt -outform der -out cert.der

- DER to PEM
~$ openssl x509 -in cert.crt -inform der -outform pem -out cert.pem

- remove a passphrase from the encrypted private.key
~$ openssl rsa -in encrypted.private.key -out private.key

- open an encrypted private key
~$ openssl rsa -in encrypted.private.key    
~$ enter password

- create a pem file from the *.crt file and *key file
    1. if the key file and cert file are already in pem format
        ~$ cat public.crt private.key > certificate.pem
    2. if the key file and cert file are in binary format
        ~$ openssl x509 -inform DER -outform PEM -in public.crt -out public.crt.pem
        ~$ rm public.crt
        ~$ mv public.crt.pem public.crt
        ~$ openssl rsa -inform DER -outform PEM -in private.key -out private.key.pem
        ~$ rm private.key
        ~$ mv private.key.pem private.key
        
Common SSL Keys Generation FLow
-------------------------------
```
# create directory
~$ mkdir -p /dev/containers/certs/external

# create private key and public cert
~$ openssl req -newkey rsa -nodes -x509 -days 365 -subj "/C=NATION_NAME/ST=STATE_NAME/L=CITY_NAME/O=ORGANIZATION_NAME/OU=ORGANIZATION_UNIT_NAME/CN=example.com/subjectAltName=DNS.1=*.example.com,DNS.2=example.com" -keyout /dev/containers/certs/external/private.key -out /dev/containers/certs/external/public.crt 

# add a passphrase to encrypt the private.key
~$ openssl rsa -des -in /dev/containers/certs/external/private.key -passout pass:changeit -out /dev/containers/certs/external/privateencrypted.key

# merge the public cert and private key into pem file
~$ cat /dev/containers/certs/external/public.crt /dev/containers/certs/external/private.key > /dev/containers/certs/external/certificate.pem
```