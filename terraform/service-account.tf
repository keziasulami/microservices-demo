resource "google_service_account" "firestore_sa" {
  account_id   = "firestore-sa"
  display_name = "firestore-sa"
}

resource "google_project_iam_member" "editor" {
  project   = var.project
  role      = "roles/owner"
  member    = "serviceAccount:${google_service_account.firestore_sa.email}"
}

resource "google_service_account" "sql_sa" {
  account_id   = "sql-sa"
  display_name = "sql-sa"
}

resource "google_project_iam_member" "cloudsql_editor" {
  project   = var.project
  role      = "roles/cloudsql.editor"
  member    = "serviceAccount:${google_service_account.sql_sa.email}"
}

resource "google_project_iam_member" "storage_admin" {
  project   = var.project
  role      = "roles/storage.admin"
  member    = "serviceAccount:${google_service_account.sql_sa.email}"
}

resource "google_service_account_iam_member" "member_kube" {
  service_account_id = google_service_account.sql_sa.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project}.svc.id.goog[default/sql-ksa]"
}
