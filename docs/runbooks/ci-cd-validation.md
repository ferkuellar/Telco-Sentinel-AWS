# Runbook - CI/CD Validation

## Steps

1. Create a new branch
2. Modify Terraform code
3. Push branch
4. Create Pull Request
5. Verify GitHub Actions execution
6. Confirm:
   - fmt passed
   - validate passed
   - plan generated
7. Download tfplan artifact
8. Review changes
9. Merge PR
10. Execute terraform apply manually
