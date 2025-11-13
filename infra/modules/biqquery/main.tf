resource "google_bigquery_dataset" "pmc" {
  dataset_id                  = "pmc_dataset"
  location                    = var.region
  delete_contents_on_destroy  = false
}

resource "google_bigquery_table" "events" {
  dataset_id = google_bigquery_dataset.pmc.dataset_id
  table_id   = "events"
  schema     = jsonencode([
    { name = "id", type = "STRING", mode = "REQUIRED" },
    { name = "ts", type = "TIMESTAMP", mode = "REQUIRED" },
    { name = "meta", type = "STRING", mode = "NULLABLE" }
  ])
}