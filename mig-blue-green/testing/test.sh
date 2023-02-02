#!/bin/bash

#
# The end-to-end test against empty sandbox project.
# Runs all steps of setup/validate/teardown in sequence.
# 
#
# Usage:
#   bash test.sh
#
#
# TODO: runner @cloudbuild.gserviceaccount.com must own sandbox project
# MAYDO: avoid check in of sandbox project id to prevent potentiall abuse
#

set -e

readonly SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
pushd "$SCRIPT_DIR/.."

gcloud builds submit \
    . \
    --config testing/test.cloudbuild.yaml \
    --substitutions _SANDBOX_PROJECT_NAME=gcb-mig-simple-test

popd