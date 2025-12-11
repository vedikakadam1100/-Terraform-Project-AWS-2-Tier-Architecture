# AWS Terraform Project: AWS 2‑Tier Architecture
## Project Overview

This project deploys a complete 2‑Tier Architecture on AWS using Terraform (IaC). The setup includes:

**Public Subnet**   → Web/App Server (EC2)

**Private Subnet** → DB Server (EC2)

**Custom VPC, Subnets, IGW, Route Table**

**Security Group** allowing SSH, HTTP, MySQL



## 🚀 Architecture Diagram (ASCII)
```
```
                     ┌────────────────────────┐
                     │        INTERNET         │
                     └────────────┬───────────┘
                                  │
                           ┌──────▼───────┐
                           │   IGW        │
                           └──────┬───────┘
                                  │
          ┌───────────────────────▼────────────────────────┐
          │                    VPC                         │
          │             CIDR: 10.0.0.0/16                  │
          │                                                │
          │   ┌──────────────────────────────┐             │
          │   │       Public Subnet          │             │
          │   │     10.0.0.0/20              │             │
          │   │ ┌────────────────────────┐   │             │
          │   │ │   Public EC2 (App)     │   │             │
          │   │ │   Auto Public IP       │   │             │
          │   │ └────────────────────────┘   │             │
          │   └──────────────────────────────┘             │
          │                                                │
          │   ┌──────────────────────────────┐             │
          │   │       Private Subnet         │             │
          │   │      10.0.16.0/20            │             │
          │   │ ┌────────────────────────┐   │             │
          │   │ │   Private EC2 (DB)     │   │             │
          │   │ └────────────────────────┘   │             │
          │   └──────────────────────────────┘             │
          └────────────────────────────────────────────────┘
```
```
---
```
terraform-project/
│
├── main.tf
├── variables.tf
├── outputs.tf
├── provider.tf (optional)
│
├── README.md ← (This file)
└── diagrams/
├── architecture.png
├── public-instance-ss.png
└── private-instance-ss.png
```
# #🧩 Terraform Components Used

✔ **1. VPC**

Custom CIDR block

Acts as the base network
![](./img/Screenshot%202025-12-11%20190656.png)

✔ **2. Public Subnet**

For App/Web server

Auto‑assign public IP enabled

![](./img/Screenshot%202025-12-11%20190732.png)

✔ **3. Private Subnet**

For DB server

No public access
![](./img/Screenshot%202025-12-11%20190732.png)

✔ **4. Internet Gateway**

Allows public server to reach the internet



✔ **5. Route Table**

Default route → 0.0.0.0/0 → IGW
![](./img/Screenshot%202025-12-11%20190857.png)

✔ **6. Security Group**

Allows:

SSH (22)

HTTP (80)

MySQL (3306)

![](./img/Screenshot%202025-12-11%20190732.png)

✔ **7. EC2 Instances**

One in public subnet → Web/App

One in private subnet → Database
![](./img/Screenshot%202025-12-11%20190949.png)


## ⚙️ Terraform Commands

terraform init

terraform plan

terraform apply -auto-approve

terraform destroy -auto-approve

## 📝 Conclusion
In this Terraform project, we successfully deployed a complete 2‑Tier Architecture on AWS. Using VPC, subnets, route tables, internet gateway, security groups, and EC2 instances, we created a secure and scalable Web Tier and Database Tier. The entire infrastructure was provisioned using Infrastructure as Code (IaC), making it fully automated, repeatable, and easy to maintain.

This project demonstrates how to design and deploy a production‑like AWS environment using Terraform efficiently and systematically.