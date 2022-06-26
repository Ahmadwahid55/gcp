# all required resources will be defined here.
# don't know
provider "google" {
  project = var.project
  region = var.region
}

resource "google_storage_bucket" "bucket" {
  name = "practice-terraform"
}

resource "google_storage_bucket_object" "object" {
  name = "source_code"
  bucket = google_storage_bucket_object.name
  source = "../HVAC-func"
}

resource "google_cloud_function" "function" {
  name = "HVAC-function"
  runtime ="python3.7"

  available_memory_mb =1000
  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.object.name
  trigger_http = true
  timeout = 60
  entry_point = "main"

}

resource "google_cloud_function_iam_member" "invoker" {
  cloud_function = google_cloud_function.function.name
  role = "role/cloudfunctions.invoker"
  member = "allUsers"
}