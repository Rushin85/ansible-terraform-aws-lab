# ansible-terraform-aws-lab
Complete DevOps project: Terraform AWS VPC + EC2, Ansible roles, NGINX automation.
This project demonstrates a full DevOps workflow using Terraform, AWS, Ansible, and NGINX.
It provisions AWS infrastructure with Terraform, then configures the EC2 instances using Ansible roles — all executed from a local development machine (VS Code + Mac).

Local Mac (VS Code + Ansible)
           │
           │ SSH (private key)
           ▼
 ┌────────────────────────────┐
 │           AWS VPC          │
 │   CIDR: 10.20.0.0/16       │
 │                            │
 │  ┌──────────────────────┐  │
 │  │   Public Subnet      │  │
 │  │   10.20.1.0/24        │  │
 │  │                      │   │
 │  │  EC2: ansible-node1  │   │
 │  │  Public IP           │   │
 │  │  NGINX installed     │   │
 │  └──────────────────────┘  │
 │                            │
 └────────────────────────────┘

Local Mac (VS Code + Ansible)
           │
           │ SSH (private key)
           ▼
 ┌────────────────────────────┐
 │           AWS VPC          │
 │   CIDR: 10.20.0.0/16       │
 │                            │
 │  ┌──────────────────────┐  │
 │  │   Public Subnet      │  │
 │  │   10.20.1.0/24        │  │
 │  │                      │   │
 │  │  EC2: ansible-node1  │   │
 │  │  Public IP           │   │
 │  │  NGINX installed     │   │
 │  └──────────────────────┘  │
 │                            │
 └────────────────────────────┘
Provisioning: Terraform
Configuration: Ansible
Web Service: NGINX
Access: SSH from local Mac

Features
 Infrastructure (Terraform)
AWS VPC (10.20.0.0/16)
Public subnet (10.20.1.0/24)
Internet Gateway + Route Table
Security Group (SSH + HTTP open)
Ubuntu EC2 instance (t3.micro)
Outputs for public/private IPs
 Automation (Ansible)
Ansible role: nginx
Installs NGINX
Ensures service is running
Deploys a custom HTML template
Uses handlers for clean restarts
 Local Development Workflow
VS Code as control machine
Ansible runs directly from Mac
SSH key authentication
Clean project structure for portfolio

Project Structure
ansible-terraform-aws-lab/
├── terraform/
│   └── ansible_lab.tf
│
└── ansible/
    ├── ansible.cfg
    ├── inventory.ini
    ├── install_nginx.yml
    └── roles/
        └── nginx/
            ├── tasks/main.yml
            ├── handlers/main.yml
            └── templates/index.html.j2

ansible-terraform-aws-lab/
├── terraform/
│   └── ansible_lab.tf
│
└── ansible/
    ├── ansible.cfg
    ├── inventory.ini
    ├── install_nginx.yml
    └── roles/
        └── nginx/
            ├── tasks/main.yml
            ├── handlers/main.yml
            └── templates/index.html.j2

How to Deploy (Step-by-Step)
1️⃣ Clone the repository
git clone git@github.com:rushin85/ansible-terraform-aws-lab.git
cd ansible-terraform-aws-lab

2️⃣ Deploy AWS Infrastructure with Terraform
Navigate to Terraform folder:
cd terraform
terraform init
terraform apply

Provide your existing AWS EC2 key pair name when prompted.
Terraform will output:
control_public_ip
node1_private_ip
node1_public_ip
Keep node1_public_ip for Ansible.

3️⃣ Configure Ansible Inventory
Inside ansible/inventory.ini:
[node1]
node1 ansible_host=<PUBLIC_IP> ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/YOURKEY.pem

4️⃣ Update ansible.cfg
[defaults]
inventory = ./inventory.ini
remote_user = ubuntu
private_key_file = ~/.ssh/YOURKEY.pem
host_key_checking = False
retry_files_enabled = False

5️⃣ Run the NGINX Role
From inside the ansible/ directory:
ansible-playbook install_nginx.yml
You should see:
NGINX installed
Template deployed
Handler restarted service

6️⃣ Test in browser
http://<public-ip>
You should see:
Welcome! This Was Deployed via Ansible During a DevOps Energy Burst
Node: node1

Skills Demonstrated
Terraform AWS provisioning
Ansible role development
Infrastructure-as-Code design
Cloud networking (VPC, subnets, routes)
Linux server configuration
SSH key management
Git + GitHub workflow
VS Code DevOps environment

Future Enhancements
Add TLS + reverse proxy NGINX
Add second EC2 + load balancing
Implement AWS dynamic inventory
Add Docker role
Integrate GitHub Actions CI pipeline

License
MIT License — free to use, modify, and learn from.