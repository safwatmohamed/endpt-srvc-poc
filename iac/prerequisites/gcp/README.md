# GCP Prerequisites

1. Update `backend.dev.conf` with your bucket name and prefix. (Note: bucket name is given in Onboarding email)
2. Update `terraform.dev.tfvars` with your project_id, region, and desired roles to be added to your Deployment Service Account
3. Review the instructions in [.github/workflows](../../../.github/workflows/) on how to add required secrets in GitHub.
4. Update `.merck.yaml` on the root and uncomment the required blocks for GCP.