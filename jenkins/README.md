About Jenkins
=============
A memo of jenkins common setup, usages and continuous integration flow

Installation
------------
download jenkins.xx.war, there are two ways to start jenkins server

1. `java -jar jenkins.xxx.war` start jenkins.xx.war using its own built-in servlet container
2. put jenkins.xxx.war inside tomcat webapp folder, start tomcat, by default, you will not be able to restart the jenkins using `http://localhost:8080/jenkins/restart`, if you want to to restart it, you need to restart the tomcat

after the jenkins server is fully loaded and started, `.jenkins` folder will be created, this is the home directory of the jenkins server, all the jobs and workspaces will be under this directory

for windows, `C:/Users/xxx/.jenkins`
for linux, `~/.jenkins`

Create Users and Groups
-----------------------
after created the admin and system user for the jenkins server, we can disable the signup capability of the jenkins server, and creating users and groups using admin users. assigning minimum required access to specific users.

Maven and Git setup
-------------------
for the jenkins.2.x.war version, it will comes along with Maven and Git plugins installed by default. For maven, it will have some default configurations in the `Maven Project Configuration` section when clicked 
`Manage Jenkins -> Configure System`

Jenkins Jobs
------------
basic build unit, every jobs should contain only one application, every jobs has its own configuration, including `Source Control Management`, `Build Triggers`, `Pre-Built Actions`, `Post-Built Actions`, `Email Notification`, `Reporting Action` and more. Each jobs can be created as a new Item as different types of project, such as `Freestyle Project` and `Maven Project`

Build Triggers are quite flexible, indicating whether the job need to be built periodically, or build while polling SCM, or build every 30 minutes, etc.

Plugins
-------
there are a lot of useful plugins available in the public plugins markets

    - junit realtime test report plugin
    - static code analysis plugin
    - sonarCube plugin
    - deploy to container plugin: used for automated deployment
    - build history metrics plugin: used to understand the builds that how frequently they fail/pass over time, (MTTF, MTTR)
    - backup plugin
    - delivery pipeline plugin
    - build pipeline plugin
    - maven plugin
    - git plugin
    - ...

Reporting
---------
reporting can be done in two ways, one way is to add a post build action for each job, and unit test coverage report will be generated after each successfully build, another way is to create a speratae jenkins job for the reporting, and this reporting job will use sonarCube plugin to do a static code analysis on the required applications and generating corresponding analysis report.

Distributed Builds
------------------
enabling the master and slave model for jenkins clustering, let the slave takes off the heavy load of the master jenkins server

each slave runs a separate program called 'slave agent', there is no need to install full jenkins on a slave

Server Maintenance
------------------
basic activities to carry out for Jenkins server maintanance best practices

    1. shutdown jenkins => http://localhost:8080/jenkins/exit
    2. restart jenkins => http://localhost:8080/jenkins/restart
    3. reload jenkins configration => http://localhost:8080/jenkins/reload
    4. setup jenkins server on the partition with mist free disk-space (taking src code and build)
       + write cronjobs or maintenance tasks that carry out clean-up operations

backup activity

    1.used to backup critical configuration settings related to jenkins
    2. backup manager -> setup -> set the backup directory -> backup hudson configuration

Cronjobs
--------
MINUTES Minutes in one hour (0-59)
HOURS Hours in one day (0-23)
DAYMONTH Day in a month (1-31)
MONTH Month in a year (1-12)
DAYWEEK Day of the week (0-7) where 0 and 7 are sunday

To allow periodically scheduled tasks to produce even load on the system, the symbol H (for “hash”) should be used wherever possible.

For example, using 0 0 * * * for a dozen daily jobs will cause a large spike at midnight. In contrast, using H H * * * would still execute each job once a day, but not all at the same time, better using limited resources.
Note also that :

The H symbol can be thought of as a random value over a range, but it actually is a hash of the job name, not a random function, so that the value remains stable for any given project.

H/30 * * * * tell jenkins to build the job every 30 minutes

By setting the schedule period to 15 13 * * * you tell jenkins to schedule the build every day of every month of every year at the 15th minute of the 13th hour of the day.

Continuos Integration
---------------------
Basic Example Flow: (For Java-based Freestyle Project)

    + .git/
    + lib/junit-4.12.jar
    + target/
    + HelloWorld.java
    + HelloWorldTest.java

1. create a freestyle jenkins job (new item), named as `QA Stage`
2. build the `QA Stage` after `DEV Stage`

for dev: (Windows Batch Command)

    ```
    javac HelloWorld.java -d target/
    cd target
    java HelloWorld
    ```
    

for qa: (Windows Batch Command)

    ```
    javac -cp "lib/junit-4.12.jar" HelloWorld.java HelloWorldTest.java -d target/
    cd target
    java HelloWorldTest
    ```

if it is a Maven Project, need to add `invoke top-level maven targets` as build-step

3. added the post build action for the `DEV Stage`, only trigger `QA Stage` new build after a successfully build of `DEV Stage`

4. install `delivery pipeline plugin`

delivery pipeline plugin installation (this will install all the dependent plugins as well)

restart jenkins server, create a new item under the Delivery Pipeline View

    => for settings:
    - check "show static analysis results"
    - check "show total build time"
    => for pipelines:
    - add jobs as components one by one

5. install `build pipeline plugin`

install the plugin, restart the jenkins server
create a new Item under the build Pipeline View