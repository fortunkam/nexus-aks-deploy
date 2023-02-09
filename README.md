# Deploy and Configure a SonaType Nexus Repository to AKS using Helm and Terraform

This repository contains a helm chart capable of deploying and configuring a [SonaType Nexus Repository](https://www.sonatype.com/nexus-repository-oss) to an Azure Kubernetes Cluster (AKS).
The Helm chart is deployed using Terraform, an Azure storage account is required before the pipelines can be run (to hold the Terraform state). 
