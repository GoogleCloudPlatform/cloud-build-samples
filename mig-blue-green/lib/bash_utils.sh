#!/bin/bash

set -e

readonly TF_CHDIR="/workspace/infra/"
readonly BUCKET_NAME="${PROJECT_ID}-tf-state"

function tf_install_in_cloud_build_step {
    echo "Installing deps"
    apt update
    apt install \
        unzip \
        wget \
        -y

    echo "Manually installing Terraform"
    wget https://releases.hashicorp.com/terraform/1.3.4/terraform_1.3.4_linux_386.zip
    unzip -q terraform_1.3.4_linux_386.zip
    mv ./terraform /usr/bin/
    rm -rf terraform_1.3.4_linux_386.zip

    echo "Verifying installation"
    terraform -v
    
    echo "Creating Terraform state storage bucket $BUCKET_NAME"
    gcloud storage buckets create \
        "gs://$BUCKET_NAME" || echo "Already exists..."
        
    echo "Configure Terraform provider and state bucket"
cat <<EOT_PROVIDER_TF > "/workspace/infra/provider.tf"
terraform {
  required_version = ">= 0.13"
  backend "gcs" {
    bucket = "$BUCKET_NAME"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.77, < 5.0"
    }
  }
}
EOT_PROVIDER_TF

    echo "$(cat /workspace/infra/provider.tf)"
}

function tf_destroy {
    echo "Running Terraform init"
    terraform \
        -chdir="$TF_CHDIR" \
        init

    echo "Running Terraform destroy"
    terraform \
        -chdir="$TF_CHDIR" \
        destroy \
        -auto-approve \
        -var project="$PROJECT_ID" \
        -var-file="main.tfvars"
}

function tf_apply {
    echo "Running Terraform init"
    terraform \
        -chdir="$TF_CHDIR" \
        init

    echo "Running Terraform apply"
    terraform \
        -chdir="$TF_CHDIR" \
        apply \
        -auto-approve \
        -var project="$PROJECT_ID" \
        -var-file="main.tfvars"
}

function describe_deployment {
    NS="ns1-"
    echo -e "Deployment configuration:\n$(cat infra/main.tfvars)"
    echo -e \
      "Here is how to connect to:" \
      "\n\t* active color MIG: http://$(gcloud compute addresses describe ${NS}splitter-address-name --region=us-west1 --format='value(address)')/" \
      "\n\t* blue color MIG: http://$(gcloud compute addresses describe ${NS}blue-address-name --region=us-west1 --format='value(address)')/" \
      "\n\t* green color MIG: http://$(gcloud compute addresses describe ${NS}green-address-name --region=us-west1 --format='value(address)')/"
    echo "Good luck!"
}
