# Specify the AWS region
region = "us-east-1"


# List of allowed principals with AWS account numbers and roles
allowed_principles = [
  {
    aws_account = 123456789012  # Example AWS account number
    role        = "MyRole"       # Example IAM role
  },
  {
    aws_account = 987654321098  # Another example AWS account number
    role        = "AnotherRole"  # Another example IAM role
  }
]
# List of backend IPs for the service and their ports
listeners={
  443:["10.50.0.1"],
  1434: ["10.50.1.1", "10.50.1.1"],
}



# Specify the port number for the service
port = 443  # Example port number for HTTPS

application_ci = "a-ci"
vendor = "a-value" 

default_tags = {
  DataClassification = "Proprietary"
  Consumer           = "ns_cloud_net@merck.com"
  Application        = "CI"
  Environment        = "Development"
  Service            = "endpoint-services"
  managed_by         = "terraform"
}
