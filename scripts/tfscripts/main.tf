resource "google_container_cluster" "primary" {
  name       = "${var.name}"
  location   = "${var.location}"
  project    = "${var.project}"
  
  initial_node_count = "${var.initial_node_count}"
  remove_default_node_pool = false
  ip_allocation_policy {
  }
  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }

  node_config {
    preemptible  = true
    machine_type = "${var.machine_type}"

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    metadata = {
      disable-legacy-endpoints = "true"
    }
  }

  timeouts {
    create = "30m"
    update = "40m"
    delete = "30m"
  }
}
