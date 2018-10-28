provider "google" {
  version = "1.4.0"
  project = "${var.project}"
  region  = "${var.region}"
}

resource "google_compute_project_metadata" "default" {
  metadata {
    # ssh-keys = "appuser:${file(var.public_key_path)}tk:${file(var.public_key_path)}"

    # Использование EOF не нравится tflint!
    ssh-keys = <<EOF
tk:${file(var.public_key_path)}
appuser:${file(var.public_key_path)}EOF
  }
}

module "vpc" {
  source = "../modules/vpc"

  source_ranges = "${var.source_ranges}"
}

module "app" {
  source = "../modules/app"

  zone             = "${var.zone}"
  count            = "${var.count}"
  app_disk_image   = "${var.app_disk_image}"
  public_key_path  = "${var.public_key_path}"
  private_key_path = "${var.private_key_path}"
}

module "db" {
  source = "../modules/db"

  zone            = "${var.zone}"
  db_disk_image   = "${var.db_disk_image}"
  public_key_path = "${var.public_key_path}"
}
