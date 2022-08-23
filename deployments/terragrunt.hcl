/******************************
TERRAGRUNT CONFIGURATION
******************************/

locals {
  # Load account, region and environment variables 
  account_vars      = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  region_vars       = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  environment_vars  = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Extract the variables we need with the backend configuration
  aws_region      = local.region_vars.locals.aws_region
  environment     = local.environment_vars.locals.environment
  state_bucket    = local.environment_vars.locals.state_bucket
  dynamodb_table  = local.environment_vars.locals.dynamodb_table
}

# Configure the Terragrunt remote state to utilize a S3 bucket and state lock information in a DynamoDB table. 
# And encrypt the state data.
remote_state {
  backend   = "s3"
  generate  = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config    = {
    bucket         = "${local.state_bucket}"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "${local.aws_region}"
    encrypt        = true
    dynamodb_table = "${local.dynamodb_table}"
  }
}

# Combine all account, region and environment variables as Terragrunt input parameters.
# The input parameters can be used in Terraform configurations as Terraform variables.  
inputs = merge(
  local.account_vars.locals,
  local.region_vars.locals,
  local.environment_vars.locals,
)
