![infra(4)](https://github.com/yurkooo97/infra-app/assets/43648928/1d331e7e-0e86-4fb9-87e4-679587f49893)
# Eschool-infra
Infrastructure for development the Eschool application product
## Description
This project allows to provision the infrastructure by Terraform using AWS as a cloud provider. Also there is an option to configure the working instances by Ansible. The deployed environment gives an opportunity to improve, test and develop the new features for Eschool project, using ready-to-work ec2 instances, rds, vpc and other aws services.
## Requirements
Terraform version more than 1.1.0, or less than 1.5.6

## Getting started
1.Clone this repo to your local environment.
2. Set your region (eu-central-1 by defult) database username and password in _variables.tf_ > rds_username > default="" and _variables.tf_ > rds_password > default="".
6. Allow Terraform to connect and authenticate successfully to AWS by creating new IAM user or use existing one and copy the access key and the secret key. Set the environment variables in your current terminal session by executing the following commands:
   
```ts
export AWS_ACCESS_KEY_ID=your_aws_access_key
export AWS_SECRET_ACCESS_KEY=your_aws_secret_access_key
```

3. Use the Terraform commands below in working directory to initialize Terraform configuration, plan and provision the infrastructure:

```ts
terraform init
terraform plan
terraform apply
```
## IMPORTANT!
For proper https access to web application the ssl certificate is needed, otherwise uncomment the ALB listeners in _alb.tf_ to have access througt load balancer by http!
Also instance profiles are using for Ansible access to instances (aws_ec2_full_access) and for CI/CD to login to ECR (ecr_role). It's needed to create them with appropriate policies, or use IAM user credentials.
