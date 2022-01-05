terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

provider "google" {
  credentials = var.credentials_file

  project = var.project
  region  = var.region
  zone    = var.zone
}

resource "google_compute_network" "vpc_network" {
  name = "terraform-network-${random_id.name.hex}"
}

resource "random_id" "name" {
  byte_length = 4
}

resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance-${random_id.name.hex}"
  machine_type = "n1-highmem-2"
#  machine_type = "n1-standard-8"
#  machine_type = "f1-micro"
  tags         = ["web", "security"]
  
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }
  
  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
    }
  }
}
