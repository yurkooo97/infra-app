![infra(4)](https://github.com/yurkooo97/infra-app/assets/43648928/1d331e7e-0e86-4fb9-87e4-679587f49893)
# Eschool-infra
Infrastructure for development the Eschool application product
## Description
This project allows to provision the infrastructure by Terraform using AWS as a cloud provider. Also there is an option to configure the working instances by Ansible. The deployed environment gives an opportunity to improve, test and develop the new features for Eschool project, using ready-to-work ec2 instances, rds, vpc and other aws services.
## Requirements
Terraform version more than 1.1.0, or less than 1.5.6

## Getting started
1. Clone this repo to your local environment.
2. Generate the ssh key or use existing one to add it _to main.tf_ > bastion_auth
3. Set your region (eu-central-1 by defult) database username and password in _variables.tf_ > rds_username > default="" and _variables.tf_ > rds_password > default="".
4. Allow Terraform to connect and authenticate successfully to AWS by creating new IAM user or use existing one and copy the access key and the secret key. Set the environment variables in your current terminal session by executing the following commands:
   
```ts
export AWS_ACCESS_KEY_ID=your_aws_access_key
export AWS_SECRET_ACCESS_KEY=your_aws_secret_access_key
```

5. Use the Terraform commands below in working directory to initialize Terraform configuration, plan and provision the infrastructure:

```ts
terraform init
terraform plan
terraform apply
```
6. Connect to Bastion via SSH and run Ansible commands:

```ts
ansible-inventory -i aws_ec2.yml --list
ansible aws_ec2 -i aws_ec2.yml -m ping --private-key=~/.ssh/bastion
ansible aws_ec2 -i aws_ec2.yml -m ping --private-key=~/.ssh/bastion
```
#### Note!
#### Before running commands above, set the ip or hostnames in ~/ansible/playbook.yml in prometheus variables to have connection with node exporters!
