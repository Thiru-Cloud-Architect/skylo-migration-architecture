resource "google_redis_instance" "primary" {
  name               = "pmc-redis"
  tier               = "STANDARD_HA"
  memory_size_gb     = 4
  region             = var.region
  authorized_network = var.vpc_id
  transit_encryption_mode = "SERVER_AUTHENTICATED"
}

output "primary_host" {
  value = google_redis_instance.primary.host
}