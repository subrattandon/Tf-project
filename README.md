# 🚀 Terraform AWS Project - EC2 with NGINX in Public Subnet

This project uses **Terraform** to create a basic AWS infrastructure that includes:

- A VPC with public & private subnets
- An Internet Gateway and Route Table
- An EC2 instance (Amazon Linux) in a public subnet
- NGINX web server automatically installed on the EC2 instance
- Security Group allowing HTTP (80) & SSH (22) access

---

## 📁 Project Structure
├── main.tf # Main Terraform configuration file
├── terraform.tfstate # Terraform state file (should be gitignored)
├── terraform.tfstate.backup
├── .terraform.lock.hcl
└── .gitignore


---

## 🌐 Resources Created

- **VPC**: `10.0.0.0/16`
- **Public Subnet**: `10.0.1.0/24`
- **Private Subnet**: `10.0.2.0/24`
- **Internet Gateway**
- **Route Table + Association**
- **EC2 Instance** (AMI: `ami-09278528675a8d54e`, Instance Type: `t3.nano`)
- **Security Group**:
  - Allows:
    - Port **80** (HTTP)
    - Port **22** (SSH)
