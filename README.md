# GCP Cloud Build CI/CD Pipeline for Cloud Run

This project demonstrates how to set up a CI/CD pipeline using Google Cloud Build to automatically build and deploy Docker images to Cloud Run.

## Project Structure

```
.
├── cloudbuild.yaml          # Production Cloud Build configuration
├── cloudbuild-staging.yaml  # Staging Cloud Build configuration
├── Dockerfile              # Docker image definition
├── app.py                  # Sample Flask application
├── requirements.txt        # Python dependencies
└── README.md              # This file
```

## Prerequisites

1. **Google Cloud Project**: You need a GCP project with billing enabled
2. **Required APIs**: Enable the following APIs in your GCP project:
   - Cloud Build API
   - Cloud Run API
   - Container Registry API
   - Cloud Resource Manager API

3. **IAM Permissions**: Ensure your service account has the following roles:
   - Cloud Build Service Account
   - Cloud Run Admin
   - Storage Admin (for Container Registry)

## Setup Instructions

### 1. Enable Required APIs

```bash
gcloud services enable cloudbuild.googleapis.com
gcloud services enable run.googleapis.com
gcloud services enable containerregistry.googleapis.com
gcloud services enable cloudresourcemanager.googleapis.com
```

### 2. Set Up Cloud Build Triggers

#### Option A: Using Google Cloud Console

1. Go to Cloud Build > Triggers
2. Click "Create Trigger"
3. Configure the trigger:
   - **Name**: `deploy-to-production`
   - **Event**: Push to a branch
   - **Repository**: Connect your repository
   - **Branch**: `main` (or your production branch)
   - **Build configuration**: Cloud Build configuration file
   - **Cloud Build configuration file location**: `/cloudbuild.yaml`

#### Option B: Using gcloud CLI

```bash
# Create trigger for production
gcloud builds triggers create github \
  --repo-name=YOUR_REPO_NAME \
  --repo-owner=YOUR_GITHUB_USERNAME \
  --branch-pattern="^main$" \
  --build-config=cloudbuild.yaml

# Create trigger for staging
gcloud builds triggers create github \
  --repo-name=YOUR_REPO_NAME \
  --repo-owner=YOUR_GITHUB_USERNAME \
  --branch-pattern="^staging$" \
  --build-config=cloudbuild-staging.yaml
```

### 3. Configure Repository Variables

The Cloud Build configuration uses the following variables:
- `$PROJECT_ID`: Your GCP project ID
- `$REPO_NAME`: Repository name
- `$COMMIT_SHA`: Git commit SHA

These are automatically provided by Cloud Build.

### 4. Customize Your Application

1. **Update Dockerfile**: Modify the Dockerfile to match your application requirements
2. **Update requirements.txt**: Add your Python dependencies
3. **Update app.py**: Replace with your actual application code
4. **Environment Variables**: Add any environment variables your application needs

## Deployment Flow

### Production Deployment
- Triggered on push to `main` branch
- Uses `cloudbuild.yaml`
- Deploys to production Cloud Run service

### Staging Deployment
- Triggered on push to `staging` branch
- Uses `cloudbuild-staging.yaml`
- Deploys to staging Cloud Run service

## Manual Deployment

You can also trigger builds manually:

```bash
# Deploy to production
gcloud builds submit --config cloudbuild.yaml

# Deploy to staging
gcloud builds submit --config cloudbuild-staging.yaml
```

## Monitoring and Logs

### View Build Logs
```bash
gcloud builds log [BUILD_ID]
```

### View Cloud Run Logs
```bash
gcloud logging read "resource.type=cloud_run_revision" --limit=50
```

### Monitor Cloud Run Service
```bash
gcloud run services describe [SERVICE_NAME] --region=us-central1
```

## Security Best Practices

1. **Use Service Accounts**: Create dedicated service accounts for different environments
2. **Limit Permissions**: Follow the principle of least privilege
3. **Secrets Management**: Use Secret Manager for sensitive data
4. **Network Security**: Configure VPC connectors if needed
5. **Image Scanning**: Enable vulnerability scanning for container images

## Cost Optimization

1. **Use Cloud Run**: Pay only for actual usage
2. **Optimize Docker Images**: Use multi-stage builds and smaller base images
3. **Set Resource Limits**: Configure CPU and memory limits appropriately
4. **Use Spot Instances**: For non-critical workloads

## Troubleshooting

### Common Issues

1. **Permission Denied**: Check IAM roles and permissions
2. **Build Failures**: Check Dockerfile and dependencies
3. **Deployment Failures**: Verify Cloud Run configuration
4. **Image Pull Errors**: Ensure Container Registry access

### Useful Commands

```bash
# Check build status
gcloud builds list

# View service details
gcloud run services list

# Check logs
gcloud logging read "resource.type=cloud_run_revision"

# Update service
gcloud run services update [SERVICE_NAME] --image=[IMAGE_URL]
```

## Next Steps

1. **Add Testing**: Integrate unit and integration tests in your pipeline
2. **Environment Variables**: Use Secret Manager for sensitive configuration
3. **Monitoring**: Set up Cloud Monitoring and alerting
4. **Blue-Green Deployment**: Implement zero-downtime deployments
5. **Custom Domains**: Configure custom domains for your Cloud Run services

## Support

For issues and questions:
- [Cloud Build Documentation](https://cloud.google.com/build/docs)
- [Cloud Run Documentation](https://cloud.google.com/run/docs)
- [Google Cloud Support](https://cloud.google.com/support) 