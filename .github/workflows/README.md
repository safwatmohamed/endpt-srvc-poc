# Continuous Integration (CI) / Continuous Delivery (CD)

> [!NOTE]  
> This template includes the baseline workflows to deploy Terraform and run releases. More workflow files can be added to this folder as your application matures.

## Setup

- `deploy-iac.yaml`: this workflow consists of two jobs
    - [`merck-gen/dso-ghwf-iac`](https://github.com/merck-gen/dso-ghwf-iac): validates IaC (terraform validate, fmt, and init), and runs a Wiz IaC scan.
        - Ensure `terraform-work-dir` is accurate.
    - [`merck-gen/dso-ghwf-cd`](https://github.com/merck-gen/dso-ghwf-cd): reads the deployment configuration from either the values passed to it in the workflow or from the `.merck.yaml` file and runs the deployment(s). Deployments using the default values can be defined in the workflow, and deployments with custom values should use the `.merck.yaml` file for configuration.

- [`.merck.yaml`](../../.merck.yaml): configuration file used by `dso-ghwf-cd`
    - Update `ci` and `serviceNowId` values for your application.
    - Update `deployments` and `environments` as needed (Default: Terraform deployments to dev, uat, prod)
  
- `release.yaml`: definition file for Release workflow
    - **Manually triggered**: merges contents from `develop` branch to `main`
    - Tags git repo with the version stated in [`VERSION`](VERSION)
    - Increases the version in the VERSION file by 1 depending on patch, minor, or major release

> [!IMPORTANT]  
> If you plan to use `release.yaml`, Contact DevSecOps support to enable **Merck - Jenkins Release Job - Prod** `merck-jenkins-release-job-prod` application in your repository. 
>   - If branch protection rules set, create an exception for the **Merck - Jenkins Release Job - Prod** `merck-jenkins-release-job-prod` application for `main` and `develop` branch (if exists).
>   - Allow application to bypass push to the branch without PR and checks.
> 
> In order for release to work correctly, the `release.yaml` file needs to be run from `main` branch. 
> 
> Make sure the file is present on `main` branch and choose `main` when running manually release workflow.

## Store Credentials in GitHub Environments

The `dso-ghwf-cd` workflow requires a [GitHub Environment](https://docs.github.com/en/actions/administering-github-actions/managing-environments-for-deployment#creating-an-environment) for each environment name passed to it (i.e., dev, uat, prod).

1. Configure GitHub Environments
    - Create environments with names corresponding to your `terraform.<env>.tfvars` files (i.e., dev, sit, prod).
        - *Settings -> Environments -> New environment*
    - Set Environment Protection Rules for non-development environments (i.e., require approval from the team members to deploy to the environment).
        - [Environments in GitHub](https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment)

2. Store Cloud Credentials as Environment Secrets
    - Each cloud provider requires certain permissions to execute a successful pipeline run (see below).

> [!TIP]  
> `dso-ghwf-cd` will automatically look for the secret names listed below in your Environments. There is no additional configuration needed after adding them.

### AWS
OIDC is the **recommended** way for AWS CLI authentication. [Configure Authentication for GitHub Actions and AWS](https://share.merck.com/pages/viewpage.action?pageId=1709183824).

The following environment variables are required to be set in the GitHub Actions environment.
- `AWS_ROLE_ARN` - AWS Role ARN with trust policy for OIDC to assume.
- `AWS_DEFAULT_REGION` - AWS Region to be set for AWS CLI.

*Alternative* - Access Key and Secret Key are also supported for AWS CLI auth.
- `AWS_ACCESS_KEY_ID` - AWS Access Key.
- `AWS_SECRET_ACCESS_KEY` - AWS Secret Key.

### Azure
The following environment variables are required to be set in the GitHub Actions environment.
- `ARM_CLIENT_ID` - Azure Service Principal Client ID.
- `ARM_CLIENT_SECRET` - Azure Service Principal Client Secret. **Not needed when using OIDC.**
- `ARM_TENANT_ID` - Azure Tenant ID.
- `ARM_SUBSCRIPTION_ID` - Azure Subscription ID.

### Google Cloud
The following environment variables are required to be set in the GitHub Actions environment.
- `GCP_SERVICE_ACCOUNT_EMAIL` - Service account email used to authenticate with Workload Identity Provider (WIP). Given during onboarding - should contain `gha` in name.
- `GCP_DEPLOYMENT_SERVICE_ACCOUNT_EMAIL` - Deployment Service account used to deploy resources into your project. Given during onboarding - should contain `deployment` in name.