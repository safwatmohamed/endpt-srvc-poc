# Continuous Integration (CI) / Continuous Delivery (CD)

> [!NOTE]  
> This template includes the baseline workflows to deploy an endpoint service with terraform

## Setup

## Store Credentials in GitHub Environments

1. Configure GitHub Environments
    - Create environments with names corresponding to your `terraform.<env>.tfvars` files (i.e., dev, sit, prod).
        - *Settings -> Environments -> New environment*
    - Set Environment Protection Rules for non-development environments (i.e., require approval from the team members to deploy to the environment).
        - [Environments in GitHub](https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment)

2. Store Cloud Credentials as Environment Secrets
    - Each cloud provider requires certain permissions to execute a successful pipeline run (see below).

### AWS
OIDC is the **recommended** way for AWS CLI authentication. [Configure Authentication for GitHub Actions and AWS](https://share.merck.com/pages/viewpage.action?pageId=1709183824).

The following environment variables are required to be set in the GitHub Actions environment.
- `AWS_ROLE_ARN` - AWS Role ARN with trust policy for OIDC to assume.
- `AWS_DEFAULT_REGION` - AWS Region to be set for AWS CLI.

*Alternative* - Access Key and Secret Key are also supported for AWS CLI auth.
- `AWS_ACCESS_KEY_ID` - AWS Access Key.
- `AWS_SECRET_ACCESS_KEY` - AWS Secret Key.
