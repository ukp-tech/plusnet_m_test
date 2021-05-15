# plusnet_m_test

Public AMI id : Plusnet_M_Test - ami-0d7f896f0668f1bca

1. The default ssh port is configured as 42 (  while using this AMI , open CUSTOM TCP 42 port from security group ) also the default login is disabled . Login to the AMI use credentials : username : plusnet , Password : Plusnet@123
   
   N.B : at point of select an exisiting key pain . Please do select **Proceed without the keypair**
   
3. The default ec2-instance-connect has been removed 
4. Once you boot the image automatically the default services like docker , sshd etc will start 
5. Docker contanier configured for both netdata and nginx : 
    nginx : Default http port 80 is open for this . 
            You can use command line curl -Lv http://localhost/hello.html in order to get the response , Also can be asscible from browser http://<public ip>/hello.html 
    
    netdata: Default port configured is 9095/tcp . 
             can be asscible from browser http://<public ip>:9095/
5. log rotation configuration modified to rotate and compress the log file every 1 hour, retaining a maximum of 10 rotated logs.


**With Terraform **

Used to terraform to provision the EC2 instance with respecitve volume storage and security groups . 
main.tf --> contains complete  aws resouce creation logic
provider.tf --> Contain the IAM user creds to allow terraform to login AWS and do operations. 


