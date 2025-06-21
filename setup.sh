#!/bin/bash

# GCP Cloud Build CI/CD Setup Script
# This script helps set up the initial configuration for your CI/CD pipeline

set -e

echo "🚀 Setting up GCP Cloud Build CI/CD Pipeline..."

# Check if gcloud is installed
if ! command -v gcloud &> /dev/null; then
    echo "❌ gcloud CLI is not installed. Please install it first:"
    echo "   https://cloud.google.com/sdk/docs/install"
    exit 1
fi

# Check if user is authenticated
if ! gcloud auth list --filter=status:ACTIVE --format="value(account)" | grep -q .; then
    echo "❌ You are not authenticated with gcloud. Please run:"
    echo "   gcloud auth login"
    exit 1
fi

# Get project ID
PROJECT_ID=$(gcloud config get-value project 2>/dev/null)
if [ -z "$PROJECT_ID" ]; then
    echo "❌ No project is set. Please set a project:"
    echo "   gcloud config set project YOUR_PROJECT_ID"
    exit 1
fi

echo "✅ Using project: $PROJECT_ID"

# Enable required APIs
echo "📡 Enabling required APIs..."
gcloud services enable cloudbuild.googleapis.com
gcloud services enable run.googleapis.com
gcloud services enable containerregistry.googleapis.com
gcloud services enable cloudresourcemanager.googleapis.com

echo "✅ APIs enabled successfully"

# Get the Cloud Build service account
CLOUDBUILD_SA="$(gcloud projects describe $PROJECT_ID --format='value(projectNumber)')@cloudbuild.gserviceaccount.com"

echo "🔐 Setting up IAM permissions for Cloud Build service account: $CLOUDBUILD_SA"

# Grant necessary permissions to Cloud Build service account
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$CLOUDBUILD_SA" \
    --role="roles/run.admin"

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$CLOUDBUILD_SA" \
    --role="roles/storage.admin"

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$CLOUDBUILD_SA" \
    --role="roles/iam.serviceAccountUser"

echo "✅ IAM permissions configured"

# Create a simple trigger (optional - user can customize later)
echo "🎯 Creating Cloud Build trigger..."
echo "   Note: You may need to connect your repository first in the Cloud Console"
echo "   Go to: https://console.cloud.google.com/cloud-build/triggers"

# Display next steps
echo ""
echo "🎉 Setup completed successfully!"
echo ""
echo "📋 Next steps:"
echo "1. Connect your repository to Cloud Build:"
echo "   https://console.cloud.google.com/cloud-build/triggers"
echo ""
echo "2. Create a trigger for your repository:"
echo "   - Name: deploy-to-production"
echo "   - Event: Push to a branch"
echo "   - Branch: main"
echo "   - Build configuration: Cloud Build configuration file"
echo "   - Cloud Build configuration file location: /cloudbuild.yaml"
echo ""
echo "3. Test your pipeline by pushing to the main branch"
echo ""
echo "4. Monitor your builds:"
echo "   https://console.cloud.google.com/cloud-build/builds"
echo ""
echo "5. View your Cloud Run services:"
echo "   https://console.cloud.google.com/run"
echo ""
echo "📚 For more information, see the README.md file" 