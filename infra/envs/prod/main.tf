terraform {
  required_version = ">= 1.5.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.35"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 5.35"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}


# Enable required services
resource "google_project_service" "services" {
  for_each = toset([
    "compute.googleapis.com",
    "container.googleapis.com",
    "run.googleapis.com",
    "cloudsql.googleapis.com",
    "bigquery.googleapis.com",
    "dataflow.googleapis.com",
    "redis.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "secretmanager.googleapis.com",
    "iap.googleapis.com",
    "servicenetworking.googleapis.com",
    "cdn.googleapis.com"
  ])
  project                    = var.project_id
  service                    = each.value
  disable_on_destroy         = false
}

# setup network using the module pre-built
module "network" {
  source = "../../modules/network"
  region = var.region
}

# call cdn configurations pre-built in storage_cdn module
module "frontend_cdn" {
  source      = "../../modules/storage_cdn"
  project_id  = var.project_id
  region      = var.region
  domain_name = var.domain_name
}

# call cloud run (for simple example) from cloudrun pre built module
module "cloud_run" {
  source    = "../../modules/cloud_run"
  project_id= var.project_id
  region    = var.region
  image     = "gcr.io/${var.project_id}/pmc-backend:latest"
  db_host   = module.sql_mysql.private_ip
  db_user   = "appuser"
  db_name   = "pmc"
  redis_host= module.redis.primary_host
}

# setup redis through the similar way
module "redis" {
  source = "../../modules/memorystore_redis"
  region = var.region
  vpc_id = module.network.vpc.id
}