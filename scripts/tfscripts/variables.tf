variable "name" {
  default = "knoteapp"
}

variable "credentials" {
  default = "account.json"
}

variable "project" {
  default = "tranquil-buffer-264907"
}

variable "location" {
  default = "us-central1-a"
}

variable "gcp_region" {
  default = "us-central1"
}

variable "initial_node_count" {
  default = 2
}

variable "machine_type" {
  default = "g1-small"  
}
