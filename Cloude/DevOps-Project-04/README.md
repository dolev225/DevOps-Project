# Cloud storage: AWS with Terraform

> Infrastructure as Code: An AWS application that uploads files to an S3 bucket, deployed with a single `terraform apply`.

![AWS](https://img.shields.io/badge/AWS-ALB%20%2B%20EC2%20%2B%20S3-FF9900?logo=amazonaws&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-IaC-7B42BC?logo=terraform&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-Container-2496ED?logo=docker&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-Ubuntu-E95420?logo=ubuntu&logoColor=white)

---

## 📖 Overview

This project uses **Terraform** to provision a complete cloud storage web application on AWS. It includes an Application Load Balancer, a target group with health checks, security groups, and an Auto Scaling Group managing EC2 instances running a Docker container with a user-friendly Web GUI.

Users can create an account, log in, and upload files through the web interface directly to an AWS S3 bucket, allowing you to easily view and compare uploaded files on both the frontend and the AWS S3 console.

**What this project covers:**
- Defining infrastructure as code using Terraform
- Provisioning an Application Load Balancer, Target Group, Listeners, and Health Checks
- Setting up an Auto Scaling Group (ASG) maintaining a minimum of 2 EC2 instances (scaling up to 5 under heavy load)
- Controlling network traffic with public and private Security Groups
- Automated server bootstrap and provisioning via a shell script (`install.sh`)
- Exposing the application via the Load Balancer DNS output
- Clean teardown with `terraform destroy`

---

## 🏗️ Architecture

```mermaid
flowchart TB
    U(["👤 User / Browser"]) -->|"HTTP :80"| ALB

    subgraph AWS["☁️ AWS Cloud"]
        ALB["Application Load Balancer"]
        TG["Target Group<br/>health check: GET /"]
        
        subgraph ASG["Auto Scaling Group (2-5 instances)"]
            S1["EC2 Instance 1<br/>Docker App (GUI)"]
            S2["EC2 Instance 2<br/>Docker App (GUI)"]
        end
        
        S3["S3 Bucket<br/>(File Storage)"]

        ALB --> TG
        TG --> S1
        TG --> S2
        S1 -.->|"Upload Files"| S3
        S2 -.->|"Upload Files"| S3
    end

    style AWS fill:#FAEEDA,stroke:#854F0B,color:#412402
