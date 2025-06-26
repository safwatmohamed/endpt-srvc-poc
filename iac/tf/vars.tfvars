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
  443:["10.1.0.1", "10.1.0.2", "10.1.0.3"],
  1434: ["10.2.0.0", "10.2.0.1"],
  5432: ["10.3.0.0"]
}



# Specify the port number for the service
port = 443  # Example port number for HTTPS

application_ci = "ci"
vendor = "value" 

default_tags = {
  DataClassification = "Proprietary"
  Consumer           = "ns_cloud_net@merck.com"
  Application        = "CI"
  Environment        = "Development"
  Service            = "endpoint-services"
}
