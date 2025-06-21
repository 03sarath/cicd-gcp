#!/bin/bash

# Script to fix Cloud Build service account permissions
# This script grants the necessary permissions for Cloud Build to manage Cloud Run IAM policies

set -e

echo "🔧 Fixing Cloud Build service account permissions..."

# Get project ID
PROJECT_ID=$(gcloud config get-value project 2>/dev/null)
if [ -z "$PROJECT_ID" ]; then
    echo "❌ No project is set. Please set a project:"
    echo "   gcloud config set project YOUR_PROJECT_ID"
    exit 1
fi

echo "✅ Using project: $PROJECT_ID"

# Get the Cloud Build service account
CLOUDBUILD_SA="$(gcloud projects describe $PROJECT_ID --format='value(projectNumber)')@cloudbuild.gserviceaccount.com"

echo "🔐 Adding IAM permissions for Cloud Build service account: $CLOUDBUILD_SA"

# Grant IAM Security Admin role to manage IAM policies
echo "📝 Adding IAM Security Admin role..."
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$CLOUDBUILD_SA" \
    --role="roles/iam.securityAdmin"

# Grant Service Account Admin role for managing service accounts
echo "📝 Adding Service Account Admin role..."
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$CLOUDBUILD_SA" \
    --role="roles/iam.serviceAccountAdmin"

echo "✅ Permissions updated successfully!"
echo ""
echo "🔄 Now you can retry your Cloud Build deployment."
echo "   The service account should now have permission to set IAM policies on Cloud Run services." 