#!/bin/bash

# Script to fix Cloud Run service access permissions
# This script allows unauthenticated access to your Cloud Run service

set -e

echo "🔧 Fixing Cloud Run service access permissions..."

# Get project ID
PROJECT_ID=$(gcloud config get-value project 2>/dev/null)
if [ -z "$PROJECT_ID" ]; then
    echo "❌ No project is set. Please set a project:"
    echo "   gcloud config set project YOUR_PROJECT_ID"
    exit 1
fi

echo "✅ Using project: $PROJECT_ID"

# Get the service name from the URL
# Extract service name from URL like: https://cicd-gcp-642429392474.us-central1.run.app
SERVICE_NAME="cicd-gcp"
REGION="us-central1"

echo "🔍 Fixing access for service: $SERVICE_NAME in region: $REGION"

# Allow unauthenticated access
echo "📝 Adding IAM policy binding for unauthenticated access..."
gcloud run services add-iam-policy-binding $SERVICE_NAME \
    --region=$REGION \
    --member="allUsers" \
    --role="roles/run.invoker"

echo "✅ Access permissions updated successfully!"
echo ""
echo "🌐 Your service should now be accessible at:"
echo "   https://$SERVICE_NAME-$PROJECT_ID.$REGION.run.app"
echo ""
echo "🔍 You can also check the service status with:"
echo "   gcloud run services describe $SERVICE_NAME --region=$REGION" 