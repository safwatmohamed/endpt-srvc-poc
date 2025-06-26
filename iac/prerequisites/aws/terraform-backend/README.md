# Terraform Backend deployment

A CloudFormation template that sets up an S3 bucket for storing the terraform.tfstate file and a DynamoDB table to prevent multiple changes at once.

1) Configure the `parameters.<env>.json` file
    - Add appropriate values to each environment parameters file.
    - You will need to replace values for `<BUCKET_NAME>`, `<REPLICATION_BUCKET_NAME>` and `<DYNAMO_DB_TABLE_NAME>`.
        - `<BUCKET_NAME>` and `<REPLICATION_BUCKET_NAME>` need to be **globally unique** names in AWS (recommend to include `<env>` in the name).
        - `<DYNAMO_DB_TABLE_NAME>` can be the same across AWS accounts.

2) Authenticate AWS CLI to your account within the Terminal

    - Navigate to [go/aws-sso](https://go.merck.com/aws-sso) in your browser and find the AWS account you'd like to deploy to
        - Select `Command line or programmatic access` for the role you'd like to deploy with
        - Utlize **Option 1** to copy `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, and `AWS_SESSION_TOKEN` for both Mac and Windows
        - Paste the commands into your terminal
            - Note: you can run `aws sts get-caller-identity` to confirm your role

3) (Optional) Modify default values in  prerequisites deployment script [create-tfm-backend.sh](create-tfm-backend.sh)

    - Change values of `REPLICA_STACK`, `REPLICA_REGION`, `BACKEND_STACK` and `BACKEND_REGION` at the top of the [create-tfm-backend.sh](create-tfm-backend.sh) script.

> [!CAUTION]
> `REPLICA_STACK` and `BACKEND_STACK` need to be unique within your account
>
> Do not modify the remainder of the file - this script will deploy your backend based on the input parameters you've provided

4) Run [create-tfm-backend.sh](create-tfm-backend.sh) script

    - Navigate in your terminal to [iac/prerequisites/aws/terraform-backend](.) folder.
    - Use command `chmod +x create-tfm-backend.sh` in the terminal to compile the script
    - Run command `./create-tfm-backend.sh <ENVIRONMENT>` with the environment value to match the `<env>` in the `parameters.<env>.json` file
        - ex. If you are planning on running the values within `parameters.dev.json`, run the following command:
            - `./create-tfm-backend.sh dev`

> [!IMPORTANT]
> You need to have `jq` installed for this script to run successfully (ex: `brew install jq`).

```bash
cd iac/prerequisites/aws/terraform-backend
chmod +x create-tfm-backend.sh
./create-tfm-backend.sh dev
```

5) Proceed to [deployment-role guide](../deployment-role/README.md)

If there was no error during execution of the script, your S3 and DynamoDB resources have been created and you now have a place to store Terraform state files! If there was an error, investigate it in the AWS console. Find stack that errored out and make a corrections.

> [!TIP]
> Take note of the console output listing the `REMOTE BACKEND VARIABLES`. These values will be needed for future setup.
