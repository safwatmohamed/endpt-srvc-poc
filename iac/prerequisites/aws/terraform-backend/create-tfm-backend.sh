#!/bin/bash
set -euo pipefail

ENV=$1

###### #########
REPLICA_STACK=tf-prereqs-replication-bucket-stack # (OPTIONAL) Change this if you want to use a different stack name
REPLICA_REGION=us-east-2
BACKEND_STACK=tf-prereqs-backend-stack # (OPTIONAL) Change this if you want to use a different stack name
BACKEND_REGION=us-east-1
######################

get_stack_status() {
  STACK_NAME=$1
  AWS_REGION_ID=$2
  echo "[DEBUG] get_stack_status()"
  echo "[INFO]  Running describe stack command to check stack ${STACK_NAME} status..."
  set +e
  describe_stack_output=$(aws cloudformation describe-stacks --stack-name "${STACK_NAME}" --region "${AWS_REGION_ID}" --output json)
  describe_exit_code=$?
  stack_status=$(echo ${describe_stack_output} | jq -r '.Stacks[] | .StackStatus')
  set -e
  echo "[INFO]  stack_status=${stack_status}"
}

update_stack(){
  # # S3 Replication TF State Bucket
  CURR_STACK_NAME=$1
  CURR_STACK_REGION=$2
  get_stack_status ${CURR_STACK_NAME} ${CURR_STACK_REGION}
  if [ ${describe_exit_code} -eq 0 ]; then
    operation="update-stack"
  else
    operation="create-stack"
  fi
  echo "[INFO]  operation=${operation}"
  set +e

  output_stack=$(aws cloudformation ${operation} \
      --region ${CURR_STACK_REGION} \
      --output json \
      --stack-name ${CURR_STACK_NAME} \
      --template-body ${TEMPLATE} \
      --capabilities CAPABILITY_IAM \
      --parameters "${PARAMETERS}" 2>&1)
  ex_code=$?
  set -e
  if [[ "${ex_code}" != "0" && "${output_stack}" == *"No updates are to be performed."* ]]; then
    echo "[INFO]  Stack ${CURR_STACK_NAME} is up-to-date. No updates are to be performed."
    stack_completed=true
  elif [[ "${ex_code}" != "0" ]]; then
    echo "[ERROR] Failed: ${output_stack}"
    exit
  else
    timeout_seconds=120
    elapsed_seconds=0
    stack_completed=false

    while [[ ${elapsed_seconds} -lt ${timeout_seconds} ]]; do
      get_stack_status ${CURR_STACK_NAME} ${CURR_STACK_REGION}
      echo "[INFO]  stack_status=${stack_status}"

      if [[ ${stack_status} == "ROLLBACK_COMPLETE" ]]; then
          echo "Stack ${CURR_STACK_NAME} creation in region ${CURR_STACK_REGION} encountered an error and rolled back."
          exit 1
      elif [[ "${stack_status}" == *"COMPLETE"* ]]; then
        echo ""
        echo "Stack creation completed successfully!"
        stack_completed=true
        break
      fi
      echo "[INFO]  Stack ${CURR_STACK_REGION} is still in progress. Waiting..."
      sleep 10
      elapsed_seconds=$((elapsed_seconds + 10))
    done
  fi
}

# # S3 Replication TF State Bucket
echo ""
echo "################ Deploying ${REPLICA_STACK} to ${REPLICA_REGION} region..."
stack_completed=false
PARAMETERS="file://parameters.${ENV}.json"
TEMPLATE="file://state-backend-s3-replication.yaml"
update_stack "${REPLICA_STACK}" "${REPLICA_REGION}"

# S3 TF State Bucket and DynamoDB Table
if [[ "${stack_completed}" == "true" ]]; then
    echo ""
    echo "################ Deploying ${BACKEND_STACK} to ${BACKEND_REGION} region..."
    echo "[INFO]  Getting key with alias 'aws/s3' from region ${REPLICA_REGION}...."
    S3_KEY_ID=$(aws kms describe-key --key-id alias/aws/s3 --region ${REPLICA_REGION} --output json | jq -r '.KeyMetadata.KeyId' )
    echo "[INFO]  S3_KEY_ID=${S3_KEY_ID}"
    PARAMETERS=$(cat parameters.${ENV}.json | jq -r ". + [{\"ParameterKey\":\"S3KeyID\", \"ParameterValue\" : \"${S3_KEY_ID}\"} , {\"ParameterKey\":\"ReplicaS3Region\", \"ParameterValue\": \"${REPLICA_REGION}\"}]")
    TEMPLATE="file://state-backend-s3.yaml"
    update_stack "${BACKEND_STACK}" "${BACKEND_REGION}"
else
    echo "[ERROR] Unable to Create Application Bucket, Replica Bucket did not complete successfully."
    exit 1
fi
echo ""
echo "Put the following configuration in your terraform backend configuration file (backend.${ENV}.conf) :"
echo "############################"
echo "# REMOTE BACKEND VARIABLES #"
echo "############################"
echo "bucket         = \"$(aws cloudformation describe-stacks --stack-name ${BACKEND_STACK} --region ${BACKEND_REGION} --query 'Stacks[0].Outputs[?OutputKey==`TerraformStateS3BucketName`].OutputValue' --output text)\""
echo "key            = \"deployment-role/terraform.tfstate\" # Use this key for deployment role deployment"
echo "# key            = \"app/terraform.tfstate\" # Use this key for your application infrastructure deployment"
echo "encrypt        = \"true\""
echo "dynamodb_table = \"$(aws cloudformation describe-stacks --stack-name ${BACKEND_STACK} --region ${BACKEND_REGION} --query 'Stacks[0].Outputs[?OutputKey==`TerraformStateLockDynamoDBTableName`].OutputValue' --output text)\""
echo "region         = \"${BACKEND_REGION}\""
echo ""
