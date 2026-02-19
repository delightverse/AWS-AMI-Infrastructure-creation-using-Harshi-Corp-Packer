packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}

variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region to build AMI"
}

variable "ami_name_prefix" {
  type    = string
  default = "packer-demo"
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "${var.ami_name_prefix}-{{timestamp}}"
  instance_type = "t3.micro"
  region        = var.aws_region
  
  # Find latest Ubuntu 22.04 LTS AMI
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"] # Canonical's AWS account
  }
  
  ssh_username = "ubuntu"
  
  # AMI Tag
  tags = {
    Name          = "Packer-Demo"
    Environment   = "Development"
    BuildTool     = "Packer"
    Purpose       = "LFX-Packer-Demo"
    OS            = "Ubuntu-22.04"
    BuildDate     = "{{timestamp}}"
  }
  
  # Tag the build instance
  run_tags = {
    Name = "Packer-Build-Instance"
  }
}

build {
  name    = "ubuntu-customized"
  sources = ["source.amazon-ebs.ubuntu"]
  
  # Update system and install common tools
  provisioner "shell" {
    inline = [
      "echo '========================================='",
      "echo 'Starting system configuration...'",
      "echo '========================================='",
      "sudo apt-get update",
      "sudo apt-get upgrade -y",
      "echo 'Installing Docker...'",
      "sudo apt-get install -y docker.io",
      "sudo systemctl enable docker",
      "echo 'Installing development tools...'",
      "sudo apt-get install -y python3 nodejs curl git vim htop nginx",
      "echo '========================================='",
      "echo 'AMI Configuration Complete!'",
      "echo '========================================='",
      "echo 'Installed packages:'",
      "docker --version",
      "python3 --version",
      "nodejs --version",
      "git --version",
      "nginx -v",
      "curl --version",
      "vim --version",
      "htop --version"
    ]
  }
  
  # Create a build manifest for documentation
  post-processor "manifest" {
    output     = "manifest.json"
    strip_path = true
  }
}