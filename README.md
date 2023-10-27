![infra(4)](https://github.com/yurkooo97/infra-app/assets/43648928/1d331e7e-0e86-4fb9-87e4-679587f49893)
# Eschool-infra
Infrastructure for development the Eschool application product
## Description
This project allows to provision the infrastructure by Terraform using AWS as a cloud provider. Also there is an option to configure the working instances by Ansible. The deployed environment gives an opportunity to improve, test and develop the new features for Eschool project, using ready-to-work ec2 instances, rds, vpc and other aws services.
## Getting started
1. Clone this repo to your local environment.
2. Allow Terraform to connect and authenticate successfully to AWS by creating new IAM user or use existing one and copy the access key and the secret key. Set the environment variables in your current terminal session by executing the following commands:
   
```ts
export AWS_ACCESS_KEY_ID=your_aws_access_key
export AWS_SECRET_ACCESS_KEY=your_aws_secret_access_key
...

3.ddd
