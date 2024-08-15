The terraform script is used to deploy the following infrastructure in Azure.

Resource Group
Managed Identity
Container Registry
Virtual Network & two Subnets
PostgreSQL Flexible Serer
Search Service
Storage Account
Log Analytics
Kubernetes cluster with 3 node pools (DBpool, CPSpool & APPpool)


# 3 stages

# Deploy the infrastructure -- terraform
# Pull images/ secrets & certifcate into keyvault - powershell
# Helm chart deployment to k8s - Helmchart