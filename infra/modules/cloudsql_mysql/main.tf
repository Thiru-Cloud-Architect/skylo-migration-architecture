# Private service networking
resource "google_compute_global_address" "private_ip_alloc" {
  name          = "sql-private-ip"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = var.vpc_id
}

resource "google_service_networking_connection" "psn" {
  network                 = var.vpc_id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_alloc.name]
}

resource "google_sql_database_instance" "mysql" {
  name             = "pmc-mysql"
  database_version = "MYSQL_8_0"
  region           = var.region

  settings {
    tier            = "db-custom-2-4096"
    ip_configuration {
      ipv4_enabled    = false
      private_network = var.vpc_id
    }
    backup_configuration {
      enabled = true
    }
    availability_type = "REGIONAL"
  }
  depends_on = [google_service_networking_connection.psn]
}

resource "google_sql_database" "pmc" {
  name     = "pmc"
  instance = google_sql_database_instance.mysql.name
}

resource "google_sql_user" "appuser" {
  name     = "appuser"
  instance = google_sql_database_instance.mysql.name
  password = var.db_password
}

output "private_ip" {
  value = google_sql_database_instance.mysql.private_ip_address
}