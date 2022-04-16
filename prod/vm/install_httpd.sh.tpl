#!/bin/bash
sudo yum -y update
sudo yum -y install httpd
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<html>
  <head>
<title>DOGS and CATS Webpage</title>
 </head>
 <body>
<center>
    <h1>Created by Group 13 - Roshan Fathima, Nikhil Batheja, Lakshay Anand, Raj  </h1>
    <h1>The private IP is $myip   </h1>
</center>

<table border="5" bordercolor="grey" align="center">
    <tr>
        <th colspan="3">My Favourite Pets</th> 
    </tr>
    <tr>
        <th>Spring</th>
        <th>Summer</th>
        <th>Fall</th>
    </tr>
    <tr>
        <td><img src="https://prod-group13-prooject.s3.us-east-2.amazonaws.com/ilovecats.jpg alt="" border=3 height=200 width=300></img></th>
        <td><img src="https://prod-group13-prooject.s3.us-east-2.amazonaws.com/ilovedogs.jpg" alt="" border=3 height=200 width=300></img></th>
        <td><img src="https://prod-group13-prooject.s3.us-east-2.amazonaws.com/ilovecats.jpg" alt="" border=3 height=200 width=300></img></th>
    </tr>
    <tr>
        <td>><img src="https://prod-group13-prooject.s3.us-east-2.amazonaws.com/ilovecats.jpg" alt="" border=3 height=200 width=300></img></th>
        <td><img src="https://prod-group13-prooject.s3.us-east-2.amazonaws.com/ilovedogs.jpg" alt="" border=3 height=200 width=300></img></th>
        <td><img src="https://prod-group13-prooject.s3.us-east-2.amazonaws.com/ilovecats.jpg" alt="" border=3 height=200 width=300></img></th>
    </tr>
</table>
  </body>
  <html>
"  >  /var/www/html/index.html
sudo systemctl start httpd
sudo systemctl enable httpd
