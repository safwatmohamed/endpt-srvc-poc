# Terraform code here
Your Terraform code should be placed in this directory.

## Recommended Terraform File Structure
Regardless of your cloud provider, we recommend structuring your Terraform files like below. This structure allows you to define environment specific values and streamline your CI/CD deployments to each environment.

```
main.tf
variables.tf
outputs.tf
versions.tf
terraform.dev.tfvars
terraform.sit.tfvars
terraform.prod.tfvars
backend.dev.conf
backend.sit.conf
backend.prod.conf
```

## Starter Code Available
> [!TIP]  
> Template code is included under [starter-code](./starter-code/) to help you get started with IAC for each Cloud environment.