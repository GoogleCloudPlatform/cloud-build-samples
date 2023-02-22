#!/bin/bash

# Copyright 2023 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# [START cloudbuild_setup_script]
set -e

BLUE='\033[1;34m'
RED='\033[1;31m'
GREEN='\033[1;32m'
NC='\033[0m'

echo -e "\n${GREEN}######################################################"
echo -e "#                                                    #"
echo -e "#  Zero-Downtime Blue/Green VM Deployments Using     #"
echo -e "#  Managed Instance Groups, Cloud Build & Terraform  #"
echo -e "#                                                    #"
echo -e "######################################################${NC}\n"

echo -e "\nSTARTED ${GREEN}setup.sh:${NC}"

echo -e "\nIt's ${RED}safe to re-run${NC} this script to ${RED}recreate${NC} all resources.\n"
echo "> Checking GCP CLI tool is installed"
gcloud --version > /dev/null 2>&1

readonly EXPLICIT_PROJECT_ID="$1"
readonly EXPLICIT_CONSENT="$2"

if [ -z "$EXPLICIT_PROJECT_ID" ]; then
    echo "> No explicit project id provided, trying to infer"
    PROJECT_ID="$(gcloud config get-value project)"
else
    PROJECT_ID="$EXPLICIT_PROJECT_ID"
fi

if [ -z "$PROJECT_ID" ]; then
    echo "ERROR: GCP project id was not provided as parameter and could not be inferred"
    exit 1
else
    readonly PROJECT_NUM="$(gcloud projects describe $PROJECT_ID --format='value(projectNumber)')"
    if [ -z "$PROJECT_NUM" ]; then
        echo "ERROR: GCP project number could not be determined"
        exit 1
    fi
    echo -e "\nYou are about to:"
    echo -e "  * modify project ${RED}${PROJECT_ID}/${PROJECT_NUM}${NC}"
    echo -e "  * ${RED}enable${NC} various GCP APIs"
    echo -e "  * make Cloud Build ${RED}editor${NC} of your project"
    echo -e "  * ${RED}execute${NC} Cloud Builds and Terraform plans to create"
    echo -e "  * ${RED}4 VMs${NC}, ${RED}3 load balancers${NC}, ${RED}3 public IP addresses${NC}"
    echo -e "  * incur ${RED}charges${NC} in your billing account as a result\n"
fi

if [ "$EXPLICIT_CONSENT" == "yes" ]; then
  echo "Proceeding under explicit consent"
  readonly CONSENT="$EXPLICIT_CONSENT"
else
    echo -e "Enter ${BLUE}'yes'${NC} if you want to proceed:"
    read CONSENT
fi

if [ "$CONSENT" != "yes" ]; then
    echo -e "\nERROR: Aborted by user"
    exit 1
else
    echo -e "\n......................................................"
    echo -e "\n> Received user consent"
fi

#
# Executes action with one randomly delayed retry.
#
function do_with_retry {
    COMMAND="$@"
    echo "Trying $COMMAND"
    (eval $COMMAND && echo "Success on first try") || ( \
        echo "Waiting few seconds to retry" &&
        sleep 10 && \
        echo "Retrying $COMMAND" && \
        eval $COMMAND \
    )
}

echo "> Enabling required APIs"
# Some of these can be enabled later with Terraform, but I personally
# prefer to do all API enablement in one place with gcloud.
gcloud services enable \
    --project=$PROJECT_ID \
    cloudbuild.googleapis.com \
    cloudresourcemanager.googleapis.com \
    compute.googleapis.com \
    sourcerepo.googleapis.com \
    --no-user-output-enabled \
    --quiet

echo "> Adding Cloud Build to roles/editor"
gcloud projects add-iam-policy-binding \
    "$PROJECT_ID" \
    --member="serviceAccount:$PROJECT_NUM@cloudbuild.gserviceaccount.com" \
    --role='roles/editor' \
    --condition=None \
    --no-user-output-enabled \
    --quiet

echo "> Adding Cloud Build to roles/source.admin"
gcloud projects add-iam-policy-binding \
    "$PROJECT_ID" \
    --member="serviceAccount:$PROJECT_NUM@cloudbuild.gserviceaccount.com" \
    --condition=None \
    --role='roles/source.admin' \
    --no-user-output-enabled \
    --quiet

echo "> Configuring bootstrap job"
rm -rf "./bootstrap.cloudbuild.yaml"
cat <<'EOT_BOOT' > "./bootstrap.cloudbuild.yaml"
tags:
- "mig-blue-green-bootstrapping"
steps:
- id: create_new_cloud_source_repo
  name: "gcr.io/cloud-builders/gcloud"
  script: |
    #!/bin/bash
    set -e

    echo "(Re)Creating source code repository"

    gcloud source repos delete \
        "copy-of-mig-blue-green" \
        --quiet || true
    
    gcloud source repos create \
        "copy-of-mig-blue-green" \
        --quiet

- id: copy_demo_source_into_new_cloud_source_repo
  name: "gcr.io/cloud-builders/gcloud"
  env:
    - "PROJECT_ID=$PROJECT_ID"
    - "PROJECT_NUMBER=$PROJECT_NUMBER"
  script: |
    #!/bin/bash
    set -e

    readonly GIT_REPO="https://github.com/GoogleCloudPlatform/cloud-build-samples.git"

    echo "Cloning demo source repo"
    mkdir /workspace/from/
    cd /workspace/from/
    git clone $GIT_REPO ./original
    cd ./original

    echo "Cloning new empty repo"
    mkdir /workspace/to/
    cd /workspace/to/
    gcloud source repos clone \
        "copy-of-mig-blue-green"
    cd ./copy-of-mig-blue-green

    echo "Making a copy"
    cp -r /workspace/from/original/mig-blue-green/* ./

    echo "Setting git identity"
    git config user.email \
        "$PROJECT_NUMBER@cloudbuild.gserviceaccount.com"
    git config user.name \
        "Cloud Build"

    echo "Commit & push"
    git add .
    git commit \
        -m "A copy of $GIT_REPO"
    git push

- id: add_pipeline_triggers
  name: "gcr.io/cloud-builders/gcloud"
  env:
    - "PROJECT_ID=$PROJECT_ID"
  script: |
    #!/bin/bash
    set -e

    echo "(Re)Creating destroy trigger"
    gcloud builds triggers delete "destroy" --quiet || true
    gcloud builds triggers create manual \
        --name="destroy" \
        --repo="https://source.developers.google.com/p/$PROJECT_ID/r/copy-of-mig-blue-green" \
        --branch="master" \
        --build-config="pipelines/destroy.cloudbuild.yaml" \
        --repo-type=CLOUD_SOURCE_REPOSITORIES \
        --quiet

    echo "(Re)Creating apply trigger"
    gcloud builds triggers delete "apply" --quiet || true
    gcloud builds triggers create cloud-source-repositories \
        --name="apply" \
        --repo="copy-of-mig-blue-green" \
        --branch-pattern="master" \
        --build-config="pipelines/apply.cloudbuild.yaml" \
        --included-files="infra/main.tfvars" \
        --quiet

EOT_BOOT

echo "> Waiting API enablement propagation"
do_with_retry "(gcloud builds list --project "$PROJECT_ID" --quiet && gcloud compute instances list --project "$PROJECT_ID" --quiet && gcloud source repos list --project "$PROJECT_ID" --quiet) > /dev/null 2>&1" > /dev/null 2>&1

echo "> Executing bootstrap job"
gcloud beta builds submit \
    --project "$PROJECT_ID" \
    --config ./bootstrap.cloudbuild.yaml \
    --no-source \
    --no-user-output-enabled \
    --quiet
rm ./bootstrap.cloudbuild.yaml

echo -e "\n${GREEN}All done. Now you can:${NC}"
echo -e "  * manually run 'apply' and 'destroy' triggers to manage deployment lifecycle"
echo -e "  * commit change to 'infra/main.tfvars' and see 'apply' pipeline trigger automatically"

echo -e "\n${GREEN}Few key links:${NC}"
echo -e "  * Dashboard: https://console.cloud.google.com/home/dashboard?project=$PROJECT_ID"
echo -e "  * Repo: https://source.cloud.google.com/$PROJECT_ID/copy-of-mig-blue-green"
echo -e "  * Cloud Build Triggers: https://console.cloud.google.com/cloud-build/triggers;region=global?project=$PROJECT_ID"
echo -e "  * Cloud Build History: https://console.cloud.google.com/cloud-build/builds?project=$PROJECT_ID"

echo -e "\n............................."

echo -e "\n${GREEN}COMPLETED!${NC}"
# [END cloudbuild_setup_script]
