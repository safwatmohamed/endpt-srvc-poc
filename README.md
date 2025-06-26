# CI/CD for Terraform deployments

This template repository contains all necessary files for Terraform deployments via CI/CD pipelines.

> [!TIP]  
> Create your repository from this template by clicking `Use this template` at the top of this page.

## Repository structure explained
- `.github/workflows` contains configuration files for GitHub Actions.
- `iac` contains all Terraform related files.
- `.merck.yaml` is a default configuration file for Merck repositories and CI/CD.
- `VERSION` is a file indicating the current version of your repository (used during releases).

----

## Prerequisites
- GitHub repository + GitHub team are created 
    - Team members are added to your GitHub team.
    - GitHub team has __ADMIN__ permissions to the GitHub repository.
    - [Merck GitHub Standards](https://share.merck.com/display/BP/GitHub+Enterprise+Managed+Users+%7C+Standards+and+Compliance)

> [!NOTE]  
> If you've created your repository from this template, we recommend the following branching strategy:
> - `main`: Production-ready branch. Deploys to SIT, UAT and PROD environments. If manual approvals are configured, the pipeline pauses before deploying to the next environment.
> - `develop`: Development branch. Deploys to **dev** environment only.
> - `feature/*`: New features. Scans IAC but doesn't run any deployments.

## Terraform Setup

> [!TIP]  
> Navigate to [iac](./iac/) to setup your Terraform.

## CI/CD Setup

With the recent introduction of [GitHub Actions in Merck](https://share.merck.com/display/BP/GitHub+Actions+%7C+Getting+Started), pipeline files can be found in the [`.github/workflows`](.github/workflows/) folder.

- [`deploy-iac.yaml`](.github/workflows/deploy-iac.yaml): definition file for IAC deployment workflow
- [`release.yaml`](.github/workflows/release.yaml): definition file for Release workflow

> [!TIP]  
> Navigate to [`.github/workflows`](.github/workflows/) to setup your CI/CD.

----

## Contact Us

> [!NOTE]
> If you identify an issue with this template, feel free to create a Pull Request or Issue! 
> 
> We encourage you to join the IAC Community of Practice on [MS Teams](https://teams.microsoft.com/l/channel/19%3Acc5325594d1543069ea7270bcd393da1%40thread.skype/Infrastructure%20as%20Code%20Practitioners?groupId=7d021e32-5295-41c2-ad7c-24f0f6de8ff4&tenantId=a00de4ec-48a8-43a6-be74-e31274e2060d) to interact with other developers.

Happy Coding :smiley: