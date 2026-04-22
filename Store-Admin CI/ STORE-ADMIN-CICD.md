# Store-Admin CI/CD Setup

Repository: `CST8915-FinalProject-StoreAdmin`

## GitHub Secrets
Add these in:
**GitHub Repo → Settings → Secrets and variables → Actions**

- `DOCKER_USERNAME` =  Docker Hub username
- `DOCKER_PASSWORD` =  Docker Hub access token
- `KUBE_CONFIG_DATA` = base64-encoded kubeconfig

## GitHub Variables
Add these in:
**GitHub Repo → Settings → Secrets and variables → Actions → Variables**

- `DOCKER_IMAGE_NAME` = `sara21167/store-admin-finalproject`
- `DEPLOYMENT_NAME` = `store-admin`
- `CONTAINER_NAME` = `store-admin`
- `K8S_NAMESPACE` = `bestbuy`

## Workflow Notes
This workflow:
1. Builds the Store-Admin Docker image
2. Pushes it to Docker Hub
3. Updates the AKS deployment
4. Verifies rollout success
