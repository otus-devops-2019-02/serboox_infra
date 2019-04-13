resource "google_storage_bucket" "storage_backet" {
  name = "tf-serboox-devops-state"

  versioning {
    enabled = true
  }

  force_destroy = true

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_storage_bucket_acl" "state_storage_bucket_acl" {
  bucket         = "${google_storage_bucket.storage_backet.name}"
  predefined_acl = "private"
}
