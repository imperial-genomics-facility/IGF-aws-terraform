# IGF Terraform confs for AWS
A repository for storing AWS Terraform config files.

## What resources will be created ?
* VPC
* Public subnets
* Private subnets
* Internet gateway for public subnets
* Route tables

## How to use it?
* Clone repo `git clone https://github.com/imperial-genomics-facility/IGF-aws-terraform.git`
* Install and initialize terraform `terraform init'
* Create a variable file `terraform.tfvars` and add following lines
```yaml
environment                = "YOUR ENV NAME"
project_name               = "YOUR PROJECT NAME"
vpc_cidr_block             = "CIDR BLOCK"
enable_nat_gateway         = false
enable_vpn_gateway         = false
name                       = "NAME"
public_subnet_cidr_blocks  = [
  "LIST OF public subnets"
  ]
private_subnet_cidr_blocks = [
  "LIST OF private subnets"
  ]
```
* Generate plan `terraform plan -out=dev.tfplan -no-color`
* Inspect plan and apply changes `terraform apply -no-color  dev.tfplan`
* Destroy infrastructure: `terraform apply -destroy`