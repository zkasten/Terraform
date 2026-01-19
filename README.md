# 🚀 AWS EC2 Provisioning with Terraform

This project automates the deployment of multiple AWS EC2 instances with unique configurations using Terraform. It allows you to manage global settings (AMI, Region, Instance Type) and individual settings (Subnet, Disk Size, Key Pair) separately and efficiently.

## 📂 Project Structure

```plaintext
Terraform/
└── AWS/
    ├── EC2.tf          # Main Terraform logic & variable definitions
    └── EC2.tfvars      # Configuration values for your infrastructure


⚙️ 1. Setting (EC2.tfvars)
You can customize your infrastructure by editing the AWS/EC2.tfvars file. This file separates data from the logic.

# Global Settings
aws_region           = "REGION"
common_ami_id        = "AMI_ID"
common_instance_type = "INSTANCE_TYPE"
common_volume_type   = "gp3"
common_user_data     = <<-EOF
                       #!/bin/bash
                       # Add your startup script here
                       EOF

# Individual Instance Configurations
instance_configs = [
  {
    name      = "Terraform-Server-01"
    subnet_id = "SUBNET_ID"
    disk_size = 50
    key_name  = "KEYPAIR_NAME"
    sg_names  = ["SECURITY_GROUP_NAME"]
  },
  {
    name      = "Terraform-Server-02"
    subnet_id = "SUBNET_ID"
    disk_size = 100
    key_name  = "KEYPAIR_NAME"
    sg_names  = ["SECURITY_GROUP_NAME"]
  }
]

🚀 2. Run Commands
Follow these steps to deploy your EC2 instances. Ensure you are in the AWS directory where the .tf files are located.

Step 1: Initialize
Download the necessary AWS providers and initialize the working directory.

cd AWS
terraform init

Step 2: Plan
Create an execution plan and save it to a file. This allows you to preview changes before they happen.

terraform plan -var-file="EC2.tfvars" -out=EC2.tfplan

Step 3: Apply
Apply the changes to reach the desired state of the configuration.

terraform apply "EC2.tfplan"

⚠️ Important Notes
Security: Do NOT commit EC2.tfvars or EC2.tfplan to public repositories if they contain sensitive information.

Gitignore: Ensure your .gitignore includes *.tfstate, *.tfplan, and .terraform/.

Cleanup: To remove all resources created by this project, run:

terraform destroy -var-file="EC2.tfvars"


