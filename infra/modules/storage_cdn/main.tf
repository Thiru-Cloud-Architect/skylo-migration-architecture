resource "google_storage_bucket" "website" {
  name          = "frontend-${var.project_id}"
  location      = var.region
  uniform_bucket_level_access = true
  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
}

resource "google_compute_backend_bucket" "frontend" {
  name        = "frontend-backend-bucket"
  bucket_name = google_storage_bucket.website.name
  enable_cdn  = true
}

# Managed cert for your domain
resource "google_compute_managed_ssl_certificate" "cert" {
  name = "frontend-cert"
  managed {
    domains = [var.domain_name]
  }
}

resource "google_compute_url_map" "urlmap" {
  name            = "frontend-urlmap"
  default_service = google_compute_backend_bucket.frontend.id
}

resource "google_compute_target_https_proxy" "https_proxy" {
  name             = "frontend-https-proxy"
  url_map          = google_compute_url_map.urlmap.id
  ssl_certificates = [google_compute_managed_ssl_certificate.cert.id]
}

resource "google_compute_global_forwarding_rule" "https_fr" {
  name                  = "frontend-https"
  target                = google_compute_target_https_proxy.https_proxy.id
  port_range            = "443"
  load_balancing_scheme = "EXTERNAL"
  ip_protocol           = "TCP"
}

# Optional: A-record to the LB IP (manage DNS outside or via google_dns_record_set)