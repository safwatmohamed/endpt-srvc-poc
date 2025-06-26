# Deployment role deployment

> [!CAUTION]
> You should first follow the [Terraform backend](../terraform-backend/README.md) deployment README steps!

1. Search and replace following strings (quotes included) in the deployment-role folder.

   - `"BACKEND_DYNAMODB_TABLE"`, `"BACKEND_BUCKET"` with the resulting values from your [Terraform backend](../terraform-backend/README.md)

2. Update the deployment_policy.json.

   - Add a new JSON block inside of `Statement` with the permissions you'd like to add. [AWS IAM Policy Overview](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies.html).

> [!TIP]
> If you're using one of our iac-shared examples, there should be an IAM policy used to deploy that example which you can use later on!
>
> To get the least-privilege permissions, you can use follow the following approach.
> Make sure your infrastrucutre is not deployed and then use our script for policy generation which you can find [here](https://github.com/merck-gen/iac-shared-parent/tree/main/scripts/iam-permission)!

3. Configure the Backend for each Environment

> [!IMPORTANT]
> It's important to have unique `key` attribute in the `backend.<ENV>.conf` for each terraform project that's using same S3 bucket!
>
> Eg. in our [iac-example-cd-hands-on-demo](https://github.com/merck-gen/iac-example-cd-hands-on-demo), we use this [key](https://github.com/merck-gen/iac-example-cd-hands-on-demo/blob/develop/iac/prerequisites/backend.dev.conf#L5) for deployment of deployment-role and [this key](https://github.com/merck-gen/iac-example-cd-hands-on-demo/blob/develop/iac/tf/backend.dev.conf#L2) for deployment of infrastructure. Otherwise, our deploment role would get destroyed!

    - Modify `backend.<env>.conf` files and input the same values that you've used for deployment of terraform backend for this specific environment.
    - eg. for `dev` environment, you'd take values from [parameters.dev.json](../terraform-backend/parameters.dev.json)

4. Provide correct account number to tfvars files

   - Review the default values in `variables.tf` and uncomment the variables in `terraform.<env>.tfvars` to change the values if needed.
   - Replace `YOUR_REPO_NAME` in the `terraform.dev.tfvars` with actual repository name so you can use OIDC role from Github Actions. Set the `create_oidc_role` to `true`.

> [!TIP]
> You can allow access from local terminal to base admin sso role or even developer sso role by using the `allow_deployment_from_local` variable.
> You can enable it for `dev` environment only!

5. Run Terraform commands on Terminal

   - Ensure your authentication to AWS CLI is still valid (Note: you can run `aws sts get-caller-identity` to confirm your role)
   - Run the following commands with the proper value inserted for `<env>`

   ```bash
   terraform init -backend-config="backend.dev.conf"
   terraform apply -var-file="terraform.dev.tfvars"
   ```

Now you are all set to try deployment of your infrastructure with Terraform! :-)
