# ⚙️ Terraform on AWS: EC2 with for_each, Outputs & Tests

![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=flat-square&logo=terraform&logoColor=white) ![AWS](https://img.shields.io/badge/AWS-232F3E?style=flat-square&logo=amazonwebservices&logoColor=white) ![Nginx](https://img.shields.io/badge/Nginx-009639?style=flat-square&logo=nginx&logoColor=white)

Hands-on Terraform project covering core concepts end to end: providers, variables, meta-arguments, conditionals, `user_data`, outputs and **Terraform tests with a mocked provider**.

## ✨ What it covers

- **EC2 instances with `for_each`** (one per named environment) and gp3 root volumes
- **Conditional expressions** for root volume size per environment
- **Security group** and **key pair** on the default VPC
- **`user_data`** script that installs and starts **Nginx**
- **Outputs**: a map of instance name → public IP
- **`terraform test`** using `mock_provider "aws"` (no real cloud calls)
- `local_file` resource for basics practice

## 📁 Structure

```
.
├── ec2.tf               # key pair, SG, EC2 (for_each)
├── variable.tf          # instance type, AMI, storage, env
├── output.tf            # public IPs
├── provider.tf / terraform.tf
├── install_nginx.sh     # user_data
├── practice.tf          # local_file example
└── tests/ec2.tftest.hcl # plan-time assertions with mocked AWS
```

## 🚀 Usage

```bash
terraform init
terraform plan
terraform apply
terraform output ec2_public_ips
terraform test
terraform destroy
```

---

## 👤 Author

**Abdur Rehman** · DevSecOps Engineer · Founder of [ARTechOps](https://artechops.com)

[LinkedIn](https://www.linkedin.com/in/muhamad-abdur-rehman-81777b366/) · [GitHub](https://github.com/abdur-rehman-tech) · [artechops.com](https://artechops.com)
