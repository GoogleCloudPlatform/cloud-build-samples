variable "project" {
  type = string
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
  type = string
  description = "Version tag for 'blue' deployment."
}

variable "MIG_VER_GREEN" {
  type = string
  description = "Version tag for 'green' deployment."
}

variable "MIG_ACTIVE_COLOR" {
  type = string
  description = "Active color (blue | green)."
}

module "splitter-lb" {
  source               = "./splitter"
  project              = var.project
  ns                   = "${var.ns}splitter-"
  active_color         = var.MIG_ACTIVE_COLOR
  instance_group_blue  = module.blue.google_compute_instance_group_manager_default.instance_group
  instance_group_green = module.green.google_compute_instance_group_manager_default.instance_group
}

module "blue" {
  source                               = "./mig"
  project                              = var.project
  app_version                          = var.MIG_VER_BLUE
  ns                                   = "${var.ns}"
  color                                 = "blue"
  google_compute_network               = module.splitter-lb.google_compute_network
  google_compute_subnetwork            = module.splitter-lb.google_compute_subnetwork_default
  google_compute_subnetwork_proxy_only = module.splitter-lb.google_compute_subnetwork_proxy_only
}

module "green" {
  source                               = "./mig"
  project                              = var.project
  app_version                          = var.MIG_VER_GREEN
  ns                                   = "${var.ns}"
  color                                 = "green"
  google_compute_network               = module.splitter-lb.google_compute_network
  google_compute_subnetwork            = module.splitter-lb.google_compute_subnetwork_default
  google_compute_subnetwork_proxy_only = module.splitter-lb.google_compute_subnetwork_proxy_only
}
