/**
 * Copyright 2023 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

# [START cloudbuild_terraform_settings]
variable "project" {
  type        = string
  description = "GCP project we are working in."
}

provider "google" {
  project = var.project
  region  = "us-west1"
  zone    = "us-west1-a"
}

variable "ns" {
  type        = string
  default     = "ns1-"
  description = "The namespace used for all resources in this plan."
}

variable "MIG_VER_BLUE" {
  type        = string
  description = "Version tag for 'blue' deployment."
}

variable "MIG_VER_GREEN" {
  type        = string
  description = "Version tag for 'green' deployment."
}

variable "MIG_ACTIVE_COLOR" {
  type        = string
  description = "Active color (blue | green)."
}
# [END cloudbuild_terraform_settings]

# [START cloudbuild_splitter_instantiation]
module "splitter-lb" {
  source               = "./splitter"
  project              = var.project
  ns                   = "${var.ns}splitter-"
  active_color         = var.MIG_ACTIVE_COLOR
  instance_group_blue  = module.blue.google_compute_instance_group_manager_default.instance_group
  instance_group_green = module.green.google_compute_instance_group_manager_default.instance_group
}
# [END cloudbuild_splitter_instantiation]

# [START cloudbuild_blue_green_instantiation]
module "blue" {
  source                               = "./mig"
  project                              = var.project
  app_version                          = var.MIG_VER_BLUE
  ns                                   = var.ns
  color                                = "blue"
  google_compute_network               = module.splitter-lb.google_compute_network
  google_compute_subnetwork            = module.splitter-lb.google_compute_subnetwork_default
  google_compute_subnetwork_proxy_only = module.splitter-lb.google_compute_subnetwork_proxy_only
}

module "green" {
  source                               = "./mig"
  project                              = var.project
  app_version                          = var.MIG_VER_GREEN
  ns                                   = var.ns
  color                                = "green"
  google_compute_network               = module.splitter-lb.google_compute_network
  google_compute_subnetwork            = module.splitter-lb.google_compute_subnetwork_default
  google_compute_subnetwork_proxy_only = module.splitter-lb.google_compute_subnetwork_proxy_only
}
# [END cloudbuild_blue_green_instantiation]
