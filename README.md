# FinalProjectGroup13
Lakshay Anand, Nikhil Batheja, Raj Kiran Reddy Narala, Roshan Fathima Sahul Hameed

Pre-requisites

1.	Three S3 bucket for storing terraform state and website images.
2.	SSH keys for production, staging and development environment.
3.	Cloud9 or similar environment having all the packages installed to access AWS environment.
4.  GIT repository with public access and invite collaborators to access the repository


Instructions
1.	Create three S3 buckets in the environment.
2.	Create a Cloud9 or similar environment having all the packages installed to access AWS environment.
3.  Run the command = git clone -b master https://github.com/RoshanFathima/FinalProjectGroup13.git
4.  
Created four branches named master, prod2, dev & staging. Include branch protection rule and check the following points.
Require a pull request before merging
Require status checks to pass before merging
Include administrators
Configure Github actions with security workflow and add tfsec and configure the code according to the main branch here it is master.
Hence every time the pull request is made to master from the lower environment the security scans take place. This way the master branch has code with no security vulnerabilities.
Create a local repository in your cloud9 environment. Create a folder named  “finalproject” and initiate the following commands “git init” and to add the user name and email follow these commands “git config –global user.name “#enter user name” and git config –global user.email “#enter user email”
Enter the remote file with this command: git remote add origin “#http link for the repo”
Enter the following commands to check the status : git status
Create the necessary files that needs to be added to the repo and save it.
Enter the command to add the file to local repo: git add . & git commit -m “#comments for the file”
Now we can push the code from local repo to remote repo by this command: git push -u origin “brand name”

