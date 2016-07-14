This is Read Me file for the demo-job project on github.
There are 3 files in demo-job git repo.
1. jenkins-poc.tf
2. variables.tf
3. userdata.sh

1. Jenkins-poc.tf
	Contains terraform definition of aws resources for forming 2 aws linux instances under 1 ELB.
2. variables.tf
	Contains all the variables used by jenkins-poc.tf. All the variables are defined in this file.
3. userdata.sh
	A simple shell script to update linux server, install nginx and enable it on system start up.
