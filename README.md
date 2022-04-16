# FinalProjectGroup13
Lakshay Anand, Nikhil Batheja, Raj Kiran Reddy Narala, Roshan Fathima Sahul Hameed

Pre-requisites

1.	Three S3 bucket for storing terraform state and website images.
2.	SSH keys for production, staging and development environment.
3.	Cloud9 or similar environment having all the packages installed to access AWS environment.
4.  GIT repository with public access and invite collaborators to access the repository


Instructions
1.	Create a S3 bucket in the environment.
2.	Create a Cloud9 or similar environment having all the packages installed to access AWS environment.
3.  Create a local repository in your cloud9 environment. Create a folder named  “finalproject” and initiate the following commands “git init” and to add the user name and email follow these commands “git config –global user.name “#enter user name” and git config –global user.email “#enter user email”
4. Enter the remote file with this command: git remote add origin “#http link for the repo”
5. Enter the following commands to check the status : git status
6. Run the command = git clone -b master https://github.com/RoshanFathima/FinalProjectGroup13.git
7. For Devlopment, Switch the directory to dev, for staging, the directory is staging and for prod, its prod.
7. Run tf init in both the network and vm folder.
8. Upload one image in all of the buckets and create a public URL for it and paste it in "install_httpd.sh.tpl" file.
9. Run tf plan and then tf apply for whatever enviroment you want to configure.
10. Once, all the enviroments are configured using above commands, switch to console and deploy the Application Load Balancer. In target groups, put all the webservers in the enviroment. 
11.	You have now successfully deployed the environment.
12.	Go to all the folders in Project and run tf destroy to clean up the environment. 









