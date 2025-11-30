📦 DevOps Lab – Full CI/CD Pipeline on AWS (Terraform + Jenkins + SonarQube + Nexus + Maven + GitHub)

This project is a fully-automated DevOps Learning Lab designed to help me gain hands-on experience with:

Infrastructure-as-Code using Terraform

CI/CD pipelines using Jenkins

Artifact management using Nexus Repository

Code quality scanning using SonarQube

Build automation using Maven

Version control using Git & GitHub

Automated provisioning of EC2 servers on AWS

SSH automation and environment configuration

Modular infrastructure design and reusable Terraform modules

The goal of this lab is to simulate a real enterprise-grade CI/CD system using the same tools used in modern DevOps teams.

🚀 Architecture Overview

The infrastructure consists of multiple EC2 servers deployed using Terraform modules:

Server	Private IP	Purpose
Jenkins Master	10.0.1.10	CI/CD pipeline engine, GitHub integration
Tomcat Server	10.0.1.11	Application deployment target for WAR files
SonarQube	10.0.1.12	Static code analysis and code quality gates
Nexus Repository	10.0.1.13	Artifact repository for Maven builds
Maven Builder	10.0.1.14	Dedicated server for compiling Java applications
Jenkins Agent	10.0.1.15	Pipeline build executor for Jenkins

All servers share:

A common VPC (10.0.0.0/16)

A common public subnet (10.0.1.0/24)

A common devops user created automatically

Passwordless SSH using the same authorized key

Shared /etc/hosts entries so they can resolve each other by hostname

Git installed for cloning/pushing repositories

Java installed for Jenkins, Maven, Tomcat, and SonarQube

🛠️ Technologies Used
Infrastructure

Terraform (modular design)

AWS EC2

AWS VPC, Subnets, Route Tables, IGW

Security Groups

User Data automation (cloud-init)

CI/CD

Jenkins Master

Jenkins Agent Node

GitHub Webhooks

Jenkinsfiles for pipelines

Tools

SonarQube → Code quality scans (port 9000)

Nexus → Artifact repository (port 8081)

Maven → Java build tool

Tomcat → Application deployment server

GitHub → Source code repository

📁 Folder Structure
devops-lab/
│
├── infra/
│   ├── main.tf               # Root Terraform file - calls modules
│   ├── providers.tf          # AWS provider definition
│   ├── variables.tf          # Input variables
│   ├── outputs.tf            # Outputs (public IPs, etc.)
│   ├── terraform.tfvars      # Local variables (ignored from Git)
│   └── modules/
│       ├── network/          # VPC, Subnet, Internet Gateway
│       ├── security-group/   # Reusable SG module
│       └── ec2-instance/     # Reusable EC2 module
│
├── scripts/
│   ├── jenkins-master-init.sh
│   ├── tomcat-init.sh
│   ├── sonar-init.sh
│   ├── nexus-init.sh
│   ├── maven-init.sh
│   └── jenkins-agent-init.sh
│
└── README.md

🧱 Terraform Infrastructure Details
🧩 Modular Architecture

Terraform is organized into reusable modules:

network → creates VPC, subnet, route tables

security-group → creates custom security groups

ec2-instance → provisions an EC2 instance with user_data scripts

Each server is provisioned using the same EC2 module, but with different:

Private IP

Hostname

Initialization script

This demonstrates Terraform best practices for reusability and maintainability.

🔐 SSH Access

Each server automatically:

Creates a devops user

Adds your public SSH key to /home/devops/.ssh/authorized_keys

Configures /etc/hosts for internal name resolution

Enables passwordless movement between servers

Example SSH command:

ssh -i ~/.ssh/id_rsa devops@<public_ip>

📦 What Each Initialization Script Does
jenkins-master-init.sh

Installs Java 17

Installs Jenkins

Configures devops user

Installs Git

Updates hosts file

tomcat-init.sh

Installs Java

Installs Tomcat server

Prepares deployment directory

Configures devops user and SSH

sonar-init.sh

Installs Docker

Runs SonarQube container

Opens port 9000

Configures devops user

nexus-init.sh

Installs Docker

Runs Nexus Repository

Opens port 8081

Configures persistent storage

maven-init.sh

Installs Maven

Installs Java

Installs Git

jenkins-agent-init.sh

Installs Java & Git

Prepares Jenkins agent workspace

Downloads agent.jar

Configures SSH

🚀 How to Deploy the Infrastructure

From the infra/ directory:

terraform init
terraform validate
terraform plan
terraform apply

Terraform will provision all six servers, configure networking, and run the bootstrap scripts.

To tear everything down and avoid charges:

terraform destroy

🔄 CI/CD Pipeline (Phase 2 – In Progress)

Once the infrastructure is active, Jenkins will be configured to:

Pull code from GitHub

Run Maven builds

Run SonarQube code quality checks

Upload artifacts (WAR files) to Nexus

Deploy to Tomcat

Execute builds on a separate Jenkins agent

This section will be expanded as pipeline automation is added.

🧾 Notes About Costs

This project uses multiple EC2 instances.

To manage AWS costs:

Use small instance types (t3.micro, t3.small)

Stop or destroy instances when not in use

Use AWS Budgets alerts

This project is intended for short learning sessions, not 24/7 uptime

🎯 Purpose of This Project

This project is designed to:

Help me master real DevOps workflows

Demonstrate infrastructure automation using Terraform

Build a fully functioning CI/CD pipeline from scratch

Provide a “hands-on lab” that I can continuously expand

Prepare me for professional DevOps roles and interviews

I will continue evolving this project with:

Docker

Kubernetes

EKS

Monitoring (Prometheus/Grafana)

Central logging (ELK)

Secrets management (AWS KMS/SSM)

✨ Future Enhancements

Jenkinsfile-based multi-stage pipeline

Dockerizing the entire toolchain

Building and deploying Docker images

Migrating to Kubernetes (EKS)

Terraform remote backend using S3 + DynamoDB

Implementing Ansible for post-provisioning tasks

👤 Author

Leo Ngwa
DevOps Engineer (In Progress)
Cloud | AWS | Terraform | Jenkins | Linux | Git | CI/CD

If you'd like, I can also generate:

A project diagram (architecture diagram)

A GitHub Actions CI/CD badge

A Contribution guide

A LICENSE file

A CHANGELOG.md
