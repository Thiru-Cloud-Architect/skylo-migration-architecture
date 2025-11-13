resource "google_service_account" "run_sa" {
  account_id   = "cloud-run-sa"
  display_name = "Cloud Run SA"
}

resource "google_cloud_run_v2_service" "api" {
  name     = "pmc-backend"
  location = var.region
  template {
    service_account = google_service_account.run_sa.email
    containers {
      image = var.image # e.g. "gcr.io/your-project/pmc-backend:latest"
      env {
        name  = "DB_HOST"
        value = var.db_host
      }
      env {
        name  = "DB_USER"
        value = var.db_user
      }
      env {
        name  = "DB_NAME"
        value = var.db_name
      }
      env {
        name  = "REDIS_HOST"
        value = var.redis_host
      }
    }
    scaling {
      min_instance_count = 0
      max_instance_count = 10
    }
  }
  ingress = "INGRESS_ALL"
}

resource "google_cloud_run_v2_service_iam_member" "invoker_all" {
  project  = var.project_id
  location = var.region
  name     = google_cloud_run_v2_service.api.name
  role     = "roles/run.invoker"
  member   = "allUsers" # change to IAM group for private access
}