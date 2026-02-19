# Automated AWS AMI Creation with HashiCorp Packer

![Packer](https://img.shields.io/badge/Packer-02A8EF?style=for-the-badge&logo=packer&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-FF9900?style=for-the-badge&logo=amazonaws&logoColor=white)
![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)

> **AWS AMI Infrastructure creation using Harshi Corp Packer**

## Project Overview

This project demonstrates Infrastructure as Code (IaC) principles by automating the creation of custom Amazon Machine Images (AMIs) using HashiCorp Packer. The resulting AMI is pre-configured with a complete development stack, ready for immediate deployment.

---

## Build Architectural Process
```
┌─────────────────────────────────────────────────────┐
│                     Packer Build Process            │
├─────────────────────────────────────────────────────┤
│  1. Launch temporary t3.micro EC2 instance          │
│  2. SSH into instance and run provisioning scripts  │
│  3. Install: Docker, Python, Node.js, Git, Nginx    │
│  4. Create AMI snapshot from configured instance    │
│  5. Terminate temporary instance                    │
│  6. Output: Production-ready AMI                    │
└─────────────────────────────────────────────────────┘
```

---

## Technologies Used

| Technology | Purpose | Version |
|------------|---------|---------|
| **Packer** | Infrastructure Image automation tool| 1.x |
| **AWS EC2** | Cloud compute platform | - |
| **Ubuntu Image** | Base operating system | 22.04 LTS |

---

## What's Included in the AMI

The custom AMI comes pre-configured with:

- **Docker Engine** - For containerized applications
- **Python 3** - For program/code development and scripting
- **Node.js** - For JavaScript applications
- **Nginx** - Production-ready web server
- **Git** - Version control system
- **Essential tools** - curl, vim, htop for system management
- **Fully updated** - All system packages upgraded to latest versions

---

## Quick Start

### Prerequisites

- AWS account with EC2 permissions (IAM user preferably)
- AWS CLI configured (`aws configure`)
- Packer installed (use your package manager to install or download from HashiCorp)

### Build the AMI
```bash
# Clone the repository
git clone https://github.com/delightverse/AWS-AMI-Infrastructure-creation-using-Harshi-Corp-Packer
cd packer_aws

# Initialize Packer plugins
packer init ubuntu-ami.pkr.hcl

# Validate configuration
packer validate ubuntu-ami.pkr.hcl

# Build the AMI (takes ~10 minutes)
packer build ubuntu-ami.pkr.hcl
```

**Output:**
```
Build 'ubuntu-customized.amazon-ebs.ubuntu' finished.
AMI: ami-077b1ef2b6b423eb7  ← The new AMI ID (yours will be different)
```

---

## Project Structure
```
packer_aws/
├── ubuntu-ami.pkr.hcl    # Main Packer configuration
├── manifest.json         # Build artifacts metadata
└── README.md            # This file
```

---

## Configuration Details

### Variables
```hcl
variable "aws_region" {
  default = "us-east-1"  # Customizable region
}

variable "ami_name_prefix" {
  default = "packer-demo"  # AMI naming convention
}
```

### Source AMI Selection

The build automatically finds the latest Ubuntu 22.04 LTS AMI from Canonical:
```hcl
source_ami_filter {
  filters = {
    name = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"
    virtualization-type = "hvm"
  }
  most_recent = true
  owners = ["099720109477"]  # Canonical's AWS account
}
```

### Provisioning

Software installation is fully automated via shell scripts:
```hcl
provisioner "shell" {
  inline = [
    "sudo apt-get update",
    "sudo apt-get upgrade -y",
    "sudo apt-get install -y docker.io curl vim nano python3 nodejs nginx git" #you can add as many packages/ applications you want
  ]
}
```

---

## What I Learnt

### Technical Skills Demonstrated

1. **Infrastructure as Code (IaC)**
   - Declarative configuration using HCL
   - Version-controlled infrastructure
   - Repeatable, automated builds

2. **AWS Cloud Services**
   - EC2 instance management
   - AMI creation and lifecycle
   - IAM permissions and security groups
   - Cost optimization with t3.micro instances

3. **DevOps Practices**
   - Automated provisioning
   - Configuration management
   - Immutable infrastructure principles

4. **System Administration**
   - Package management (apt)
   - Service configuration (Docker, Nginx)
   - Shell scripting for automation

### Key Concepts

- **Immutable Infrastructure:** Instead of updating servers, replace them with new pre-configured images
- **Golden Images:** Create standardized base images for consistent deployments
- **Automation:** Eliminate manual configuration errors through code

---

## Cleanup

### Delete the AMI (after demonstration)
```bash
# Get AMI ID
AMI_ID="ami-077b1ef2b6b423eb7"

# Deregister AMI
aws ec2 deregister-image --image-id $AMI_ID

# Find snapshot ID
SNAPSHOT_ID=$(aws ec2 describe-snapshots \
  --owner-ids self \
  --filters "Name=description,Values=*$AMI_ID*" \
  --query 'Snapshots[0].SnapshotId' \
  --output text)

# Delete snapshot
aws ec2 delete-snapshot --snapshot-id $SNAPSHOT_ID
```

---

## Future Enhancements
This project demonstrates foundational Packer skills. Potential improvements:

1. Add more provisioners (Ansible)
2. Implement testing with InSpec
3. Multi-region AMI distribution
4. Add CI/CD pipeline for automated builds
5. Implement AMI versioning strategy
6. Integrate with Terraform for complete IaC pipeline

---

## Resources

- [HashiCorp Packer Documentation](https://www.packer.io/docs)
- [AWS AMI Best Practices](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIs.html)
- [Infrastructure as Code Principles](https://www.terraform.io/intro)
---

## Contact

For questions about this project:
- GitHub: [delightverse](@delightverse)
- Email: ubahdelightgodsonokechukwu@outlook.com
- LinkedIn: [Ubah Delight Okechukwu](https://www.linkedin.com/in/ubah-delight-godson-okechukwu-79689b1a6/)