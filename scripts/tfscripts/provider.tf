provider "google" {
  version = "~> 2.5"
  credentials = "${var.credentials}"
  project = "${var.project}"
  region = "${var.gcp_region}"
}
provider "google-beta" {
  version = "~> 2.10"
  credentials = "${var.credentials}"
  project = "${var.project}"
  region = "${var.gcp_region}"
}

# Permissions needed to execute script
resource "null_resource" "chmod_sh" {
  provisioner "local-exec" {
    command = "chmod +x ../run-kube-app.sh"
  }
  provisioner "local-exec" {
    command = "chmod +x ../cleanup-kube-app.sh"
  }
}

