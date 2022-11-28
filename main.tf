terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~>3.0"
    }
  }
}

variable "gcp_region" {
  type        = string
  description = "Region to use for GCP provider"
  default     = "us-west4"
}

variable "gcp_project" {
  type        = string
  description = "Project to use for this config"
}

provider "google" {
  region  = var.gcp_region
  project = var.gcp_project
}

data "google_compute_zones" "available_zones" {}

resource "google_compute_instance" "mcserver" {
  name = "mcserver"
  zone = data.google_compute_zones.available_zones.names[0]
  tags = ["allow-minecraft", "nagios"]

  machine_type = "e2-small"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }

  network_interface {
    network = "default"

    access_config {}
  }

  metadata_startup_script = file("startup_script.sh")
}

resource "google_compute_firewall" "allow_http-egress" {
    name = "allow-minecraft-egress"
    network = "default"
    direction = "EGRESS"
  
  
    allow {
      ports = ["25565"]
      protocol = "tcp"
    }

    target_tags = ["allow-minecraft"]

    priority = 1000
  
}
resource "google_compute_firewall" "allow_http-ingress" {
    name = "allow-minecraft-ingress"
    network = "default"
    direction = "INGRESS"
  
  
    allow {
      ports = ["25565"]
      protocol = "tcp"
    }

    target_tags = ["allow-minecraft"]

    priority = 1000
  
}
resource "google_compute_firewall" "nagios" {
    name = "allow-nagios-ingress"
    network = "default"
    direction = "INGRESS"
  
  
    allow {
      ports = ["5666"]
      protocol = "tcp"
    }

    target_tags = ["nagios"]

    priority = 1000
  
}

output "ip" {
  value = "${google_compute_instance.mcserver[*].network_interface.0.access_config.0.nat_ip}"
}
