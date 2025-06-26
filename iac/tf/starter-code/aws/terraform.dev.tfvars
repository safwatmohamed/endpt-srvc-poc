######################################################################################
# Required "User Provided" Variables
# you must modify these with application specific information
######################################################################################

# Tags - the following tags will be added across all resources
default_tags = {
  Application        = "myapp"
  Consumer           = "your-email@merck.com"
  Environment        = "Development"
  DataClassification = "Proprietary"
  Service            = "some-service"
}

# AWS Account Information
account_no      = "your-account-no"
deployment_role = "your-deployment-role"
region          = "us-east-1"