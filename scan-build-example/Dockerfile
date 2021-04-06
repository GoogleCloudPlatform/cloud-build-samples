# Copyright 2021 Google LLC
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

# [START cloudbuild_scan_build_dockerfile]
# Debian10 image
FROM gcr.io/google-appengine/debian10:latest

# Ensures that the built image is always unique
RUN apt-get update && apt-get -y install uuid-runtime && uuidgen > /IAMUNIQUE
# [END cloudbuild_scan_build_dockerfile]
