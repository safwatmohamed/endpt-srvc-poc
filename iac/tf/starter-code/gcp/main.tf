# Main

######## Sample Pub/Sub Topic ##########
# Use provider alias to impersonate the Deployment Service Account to deploy resources
# Ensure you've added appropriate permissions to the Deployment Service Account during prerequisites step

resource "google_pubsub_topic" "topic" {
  provider = google.deployment_sa_alias # Impersonate the Deployment Service Account
  name     = "example-topic"
}