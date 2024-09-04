variables {
  environment = "DEV"
  project_name = "Test_Project"
  vpc_cidr_block = "10.0.0.0/16"
  enable_nat_gateway = false
  enable_vpn_gateway = false
  name = "test-pipeline"
  public_subnet_cidr_blocks = [
    "10.0.0.0/24",
    "10.0.1.0/24",
    "10.0.2.0/24"]
  private_subnet_cidr_blocks = [
    "10.0.3.0/24",
    "10.0.4.0/24",
    "10.0.5.0/24"]
}

run "valid_subnets" {
  command = plan

  assert {
    condition     = length(module.vpc.public_subnets)==3
    error_message = "Expecting three public subnets"
  }

  assert {
    condition     = length(module.vpc.private_subnets)==3
    error_message = "Expecting three private subnets"
  }
}