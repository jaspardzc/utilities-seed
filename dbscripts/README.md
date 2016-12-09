About DBScripts
===============
A memo of mongodb scripts automated loading, catering for the database data replicating when setting up new server environment.

Pre-requisites: 

- the dockerized mongodb container is running under SSL mode
- the system admin user will be created as part of the dockerized mongodb container creation. (devadmin@devadmin123)

How to RUN
----------
a. Mounting the entire dbscripts from the host machine to your dockerized mongodb container

b. execute shellscripts

Option 1:
- open the dockerized mongodb container interactive shell prompt using 
    `docker exec -it CONTAINER_NAME bash`
- execute init_users.sh first, then execute init_collections

Option 2:

    ~$ docker exec -it CONTAINER_NAME /path/to/init_users.sh
    ~$ docker exec -it CONTAINER_NAME /path/to/init_collections.sh

Option 3:

if you are using chef for provisioning and deployment automation, you can also have one cookbook for mongodb, and just wrap the option-2 command using the chef `execute` resource.

and if you want to only execute this process only when the dbscripts is getting updated, then you can put the entire dbscripts hosted under a private git repository, and use chef `git` resource to pull the latest dbscripts whenever required, and `notifies` the `execute` resource only when the `git` resource is fired.

mongo_scripts
-------------

init directory, contains all the init scripts for create users, create collections data, it will be responsible for multiple databases setup on one single mongodb server instance

    # used for database initialization
    init_users.sh
    init_collections.sh

update directory, contains all the update scripts for update users, update collections data, it will be response for update specific collection and user for one single database

    # used for database collections data and users data update
    update_users.sh
    update_collections.sh


mongo_collections
-----------------

under mongo_collections directory, there are multiple subdirectory, every sub dir is the name of a mongo database name, and then collections.

    mongo_collections/{mongo_dbname}/{collection_name}

mongo_users
-----------

for mongo db creation, the db will not be visible until you insert one collection into the db.
    
    ~$ use demo;
    # only after the next script is executed, the db will be visible in the shell prompt when you type `show dbs;`
    ~$ db.test.insert({"scriptName" : "test"});

this script will create the databases, users iteratively.