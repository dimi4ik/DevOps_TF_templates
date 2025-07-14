Deploy Terraform infrastructure with automatic approval:

1. **Pre-deployment validation**:
   - Check current directory structure for Terraform files
   - Verify Terraform configuration is valid
   - Ensure plan file exists or generate new plan

2. **Security checks**:
   - Confirm infrastructure changes are intentional
   - Validate resource configurations
   - Check for potential security issues

3. **Execute terraform apply -auto-approve**:
   - Deploy infrastructure changes automatically
   - Monitor deployment progress
   - Capture deployment output and errors

4. **Post-deployment verification**:
   - Verify successful resource creation
   - Display deployment summary
   - Show important outputs (IPs, connection strings, etc.)

5. **Provide deployment summary**:
   - Resources created/modified/destroyed
   - Deployment time and status
   - Next steps or recommendations
   - Any warnings or issues encountered

**Usage**: Run from any directory - command will automatically detect Terraform files and execute deployment from the correct location.

**Warning**: This command uses `-auto-approve` which bypasses confirmation prompts. Use with caution in production environments.

**Note**: Ensures proper validation before deployment and provides comprehensive feedback on infrastructure changes. Handles both project structures: Terraform files in root directory or in terraform/ subdirectory.
