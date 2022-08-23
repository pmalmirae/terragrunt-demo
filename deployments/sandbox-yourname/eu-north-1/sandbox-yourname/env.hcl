# Set common variables for the environment
locals {
  name           = "solution-name"
  environment    = "sandbox-yourname"
  state_bucket   = "INSERT_YOUR_STATE_BUCKET_NAME_HERE" 
  dynamodb_table = "INSERT_YOUR_STATE_LOCK_TABLE_NAME_HERE"
}
