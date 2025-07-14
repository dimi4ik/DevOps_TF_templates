Run Terraform validation checks on the current configuration:

1. Check current working directory (should be in terraform directory)
2. Run terraform fmt -recursive to format code
3. Run terraform validate to check syntax
4. Run terraform plan -out=tfplan to validate configuration
5. Show any errors or warnings found
6. Provide summary of validation results

Note: Commands should be run from the terraform directory (current working directory is already terraform/)