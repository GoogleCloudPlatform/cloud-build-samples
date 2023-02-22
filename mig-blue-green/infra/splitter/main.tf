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

variable "project" {
  type = string
}

variable "ns" {
  type = string
}

variable "instance_group_blue" {
  type = any
}

variable "instance_group_green" {
  type = any
}

variable "active_color" {
  type = any
}

locals {
  lb-network                     = "${var.ns}lb-network"
  backend-subnet                 = "${var.ns}backend-subnet"
  proxy-only-subnet              = "${var.ns}proxy-only-subnet"
  fw-allow-health-check          = "${var.ns}fw-allow-health-check"
  fw-allow-proxies               = "${var.ns}fw-allow-proxies"
  l7-xlb-basic-check             = "${var.ns}l7-xlb-basic-check"
  l7-xlb-backend-service         = "${var.ns}l7-xlb-backend-service"
  regional-l7-xlb-map            = "${var.ns}regional-l7-xlb-map"
  l7-xlb-proxy                   = "${var.ns}l7-xlb-proxy"
  l7-xlb-forwarding-rule-colored = "${var.ns}l7-xlb-forwarding-rule-colored"
  l7-xlb-forwarding-rule-active  = "${var.ns}l7-xlb-forwarding-rule-active"
}

resource "google_compute_network" "default" {
  name                    = local.lb-network
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

resource "google_compute_subnetwork" "default" {
  name                       = local.backend-subnet
  ip_cidr_range              = "10.1.2.0/24"
  network                    = google_compute_network.default.id
  private_ipv6_google_access = "DISABLE_GOOGLE_ACCESS"
  purpose                    = "PRIVATE"
  region                     = "us-west1"
  stack_type                 = "IPV4_ONLY"
}

resource "google_compute_subnetwork" "proxy_only" {
  name          = local.proxy-only-subnet
  ip_cidr_range = "10.129.0.0/23"
  network       = google_compute_network.default.id
  purpose       = "REGIONAL_MANAGED_PROXY"
  region        = "us-west1"
  role          = "ACTIVE"
}

resource "google_compute_firewall" "default" {
  name = local.fw-allow-health-check
  allow {
    protocol = "tcp"
  }
  direction     = "INGRESS"
  network       = google_compute_network.default.id
  priority      = 1000
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  target_tags   = ["load-balanced-backend"]
}

resource "google_compute_firewall" "allow_proxy" {
  name = local.fw-allow-proxies
  allow {
    ports    = ["443"]
    protocol = "tcp"
  }
  allow {
    ports    = ["80"]
    protocol = "tcp"
  }
  allow {
    ports    = ["8080"]
    protocol = "tcp"
  }
  direction     = "INGRESS"
  network       = google_compute_network.default.id
  priority      = 1000
  source_ranges = ["10.129.0.0/23"]
  target_tags   = ["load-balanced-backend"]
}

resource "google_compute_region_health_check" "default" {
  name               = local.l7-xlb-basic-check
  check_interval_sec = 5
  healthy_threshold  = 2
  http_health_check {
    port_specification = "USE_SERVING_PORT"
    proxy_header       = "NONE"
    request_path       = "/"
  }
  region              = "us-west1"
  timeout_sec         = 5
  unhealthy_threshold = 2
}

# [START cloudbuild_blue_green_capacity]
resource "google_compute_region_backend_service" "default" {
  name                  = local.l7-xlb-backend-service
  region                = "us-west1"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  health_checks         = [google_compute_region_health_check.default.id]
  protocol              = "HTTP"
  session_affinity      = "NONE"
  timeout_sec           = 30
  backend {
    group           = var.instance_group_blue
    balancing_mode  = "UTILIZATION"
    capacity_scaler = var.active_color == "blue" ? 1 : 0
  }
  backend {
    group           = var.instance_group_green
    balancing_mode  = "UTILIZATION"
    capacity_scaler = var.active_color == "green" ? 1 : 0
  }
}
# [END cloudbuild_blue_green_capacity]

resource "google_compute_region_url_map" "default" {
  name            = local.regional-l7-xlb-map
  region          = "us-west1"
  default_service = google_compute_region_backend_service.default.id
}

resource "google_compute_region_target_http_proxy" "default" {
  name    = local.l7-xlb-proxy
  region  = "us-west1"
  url_map = google_compute_region_url_map.default.id
}

resource "google_compute_forwarding_rule" "colored" {
  project               = var.project
  name                  = local.l7-xlb-forwarding-rule-colored
  provider              = google-beta
  depends_on            = [google_compute_subnetwork.proxy_only]
  region                = "us-west1"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  port_range            = "80"
  target                = google_compute_region_target_http_proxy.default.id
  network               = google_compute_network.default.id
  ip_address            = google_compute_address.active.id
  network_tier          = "STANDARD"
}

resource "google_compute_address" "active" {
  name         = "${var.ns}address-name"
  address_type = "EXTERNAL"
  network_tier = "STANDARD"
  region       = "us-west1"
}

output "google_compute_network" {
  value = google_compute_network.default
}

output "google_compute_subnetwork_default" {
  value = google_compute_subnetwork.default
}

output "google_compute_subnetwork_proxy_only" {
  value = google_compute_subnetwork.proxy_only
}
