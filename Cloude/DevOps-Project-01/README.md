# 🚀 Deploy to AWS EC2

> Deploying an application on an AWS EC2 instance as part of **DevOps Project 01**.

![AWS](https://img.shields.io/badge/AWS-EC2-FF9900?logo=amazonaws&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-Ubuntu-E95420?logo=ubuntu&logoColor=white)
![Status](https://img.shields.io/badge/status-completed-brightgreen)

---

## 📖 Overview

This project demonstrates how to provision and configure an AWS EC2 instance and deploy an application on it, following DevOps best practices.

**What you will learn / what this project covers:**

- Launching and configuring an EC2 instance
- Setting up security groups and SSH key pairs
- Installing dependencies and deploying the application
- Verifying the deployment and accessing it from the internet

<!-- TODO: Add 1-2 sentences describing the specific application you deploy. -->

---

## 🏗️ Architecture

```
┌──────────┐      HTTP/HTTPS       ┌──────────────────────────┐
│  User    │ ────────────────────► │  AWS EC2 Instance        │
│ (Browser)│                       │  ├─ Security Group       │
└──────────┘                       │  ├─ Application / Web    │
                                   │  └─ OS: Ubuntu / AL2023  │
      ▲  SSH (port 22)             └──────────────────────────┘
      │
┌──────────┐
│  DevOps  │
│ Engineer │
└──────────┘
```

<!-- TODO: Replace with a real architecture diagram image: ![Architecture](./images/architecture.png) -->

---

## 🧰 Tech Stack

| Category        | Tools                          |
|-----------------|--------------------------------|
| Cloud Provider  | AWS (EC2, VPC, Security Groups)|
| OS              | Ubuntu / Amazon Linux          |
| Web Server      | <!-- Nginx / Apache / Node --> |
| Scripting       | Bash                           |
| Version Control | Git & GitHub                   |

---

## ✅ Prerequisites

Before you begin, make sure you have:

- An active [AWS account](https://aws.amazon.com/)
- An SSH key pair (`.pem` file) created in AWS
- [AWS CLI](https://aws.amazon.com/cli/) installed and configured (optional)
- Basic knowledge of Linux command line

---

## 📁 Project Structure

```
Deploy-EC2/
├── README.md
├── <!-- script / config files -->
└── images/          # Screenshots
```

<!-- TODO: Replace with your actual file tree. -->

---

## ⚙️ Setup & Deployment

### 1. Launch the EC2 instance

1. Open the **AWS Console → EC2 → Launch Instance**
2. Choose an AMI (e.g., Ubuntu Server 22.04 LTS)
3. Select instance type (e.g., `t2.micro` – Free Tier eligible)
4. Select or create a key pair
5. Configure the Security Group:

| Type  | Protocol | Port | Source        |
|-------|----------|------|---------------|
| SSH   | TCP      | 22   | Your IP only  |
| HTTP  | TCP      | 80   | 0.0.0.0/0     |

6. Launch the instance

### 2. Connect via SSH

```bash
chmod 400 your-key.pem
ssh -i your-key.pem ubuntu@<EC2_PUBLIC_IP>
```

### 3. Install dependencies

```bash
sudo apt update && sudo apt upgrade -y
# TODO: add the packages you install, e.g.:
# sudo apt install -y nginx git
```

### 4. Deploy the application

```bash
git clone https://github.com/dolev225/DevOps-Project.git
cd DevOps-Project/Cloude/DevOps-Project-01/Deploy-EC2
# TODO: add your deployment commands
```

### 5. Verify

Open your browser and navigate to:

```
http://<EC2_PUBLIC_IP>
```

---

## 📸 Screenshots

<!-- TODO: Add screenshots of the EC2 dashboard, terminal, and the running app. -->
<!-- ![EC2 Instance](./images/ec2-instance.png) -->

---

## 🔒 Security Best Practices

- Restrict SSH access (port 22) to your own IP
- Never commit `.pem` files or credentials to Git (add them to `.gitignore`)
- Keep the OS and packages updated
- Use IAM roles instead of hard-coded access keys

---

## 🧹 Cleanup

To avoid unexpected AWS charges, terminate resources when you're done:

1. EC2 Console → select the instance → **Instance state → Terminate**
2. Delete unused Elastic IPs, volumes, and security groups

---

## 🛠️ Troubleshooting

| Problem                       | Possible Solution                                           |
|-------------------------------|-------------------------------------------------------------|
| `Permission denied (publickey)` | Check key permissions (`chmod 400`) and the username        |
| Site not reachable            | Verify Security Group allows port 80 and the service runs   |
| Connection timed out          | Check public IP, route table, and Security Group rules      |

---

## 🔮 Future Improvements

- [ ] Automate provisioning with Terraform
- [ ] Add CI/CD pipeline (GitHub Actions / Jenkins)
- [ ] Containerize with Docker
- [ ] Add monitoring with CloudWatch

---

## 👤 Author

**Dolev**
GitHub: [@dolev225](https://github.com/dolev225)

---

## 📄 License

This project is licensed under the MIT License.
