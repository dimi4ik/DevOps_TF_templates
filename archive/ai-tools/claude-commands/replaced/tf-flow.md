Run comprehensive Terraform workflow (fmt, validate, plan) on the configuration:

1. **Check current directory structure**:
   - Verify if Terraform files are in current directory or terraform/ subdirectory
   - Identify correct working directory for Terraform operations

2. **Run terraform fmt -recursive**:
   - Format all Terraform code recursively from correct directory
   - Report any files that were reformatted

3. **Run terraform validate**:
   - Validate Terraform configuration syntax from correct directory
   - Check for configuration errors
   - Verify provider requirements

4. **Run terraform plan**:
   - Generate execution plan from correct directory
   - Show what changes will be made
   - Save plan to tfplan file for potential apply
   - Display resource changes summary

5. **Provide comprehensive summary**:
   - Format results (files changed/no changes needed)
   - Validation results (success/errors)
   - Plan summary (resources to add/change/destroy)
   - Any warnings or recommendations

**Usage**: Run from any directory - command will automatically detect if Terraform files are in current directory or terraform/ subdirectory and execute the workflow from the correct location.

**Note**: This command provides a complete Terraform workflow validation and planning process, ensuring code is properly formatted, syntactically correct, and ready for deployment. Handles both project structures: Terraform files in root directory or in terraform/ subdirectory.
