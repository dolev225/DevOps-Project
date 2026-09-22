## Terraform - setup

This repository automates the deployment an CPU stresser useing Auto scailing in AWS in environment

## 📦 Prerequisites
* [Terraform](https://www.terraform.io/downloads.html) v1.0.0+
* Configured AWS CLI (`aws configure`)
  
## Architecture
This project creates:
* Web app that do a CPU stresss test
* Deploy an EC2 Instance in the Public Subnet
* Deploy an Application Load Balancer with Auto Scaling
* A **Security Group** allowing Port 80 (HTTP) and 22 (SSH).
* An **EC2 Instance** (t3.micro by default).

## 👩🏽‍🍳 The Process

I started by setting a VPC with CIDR block and define subnet affter I created them . I define routing tables and attach it to the vpc .

the next step was attach an Internet Gateway to the VPC and associate it with the public subnet so we be able to connect to the EC2 throw the ethernet after the EC2 was created i attach a secuiry group to the .

the last step was to create the LB and the Auto scaling . I  started by created a TG , I choose 'Network Load Balancer' and associate it with the VPC I created earlyer 

then attach the TG to the listeners to prot 80 .

now all it left is to setup the Auto Scaling  for that i need to create a template for the EC2 scal (which machin to open when scaling (t.3micro) ) attach the LB to the AUTO Scaling and setup the Health check to 150 sec
Configure group size and scaling to 2 min 4max .

Finally, I run a test. I run the test on AWS privet accont and connet to the dns of the LB and stress test too check the LB & Auto Sscaling.

Along the way, while building everything, I took notes on what I've learned so I don't miss out on it. I also documented the behind-the-scenes processes every time a feature was added.

This way, I understood what I've built. The funny thing is, as soon as I started to document what happened behind the scenes and the features I've added, it made me realize that we fully understand something once we've actually taken a step back, thought about it, and documented what we've done. I think this is a good practice to follow when learning something new.

## 📚 What I Learned

During this project, I've picked up important skills and a better understanding of complex ideas, which improved my logical thinking.

## 🚦 Running the Project

To run the project in your local environment, follow these steps:

1. Clone the repository to your local machine. 
2. Run `terraform init`  in the project directory to initialize terraform.
3. Run `terraform apply`  in the project directory to apply the code and enter the access key and Secret access for you AWS clint.
4. at the command line you will see the URL you the LB then test the app and you can see the skilling up/down at the AWS instanss.
