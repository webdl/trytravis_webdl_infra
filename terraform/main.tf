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

module "app" {
  source = "modules/app"

  public_key_path  = "${var.public_key_path}"
  private_key_path = "${var.private_key_path}"
  zone             = "${var.zone}"
  count            = "${var.count}"
  app_disk_image   = "${var.app_disk_image}"
}

module "db" {
  source = "modules/db"

  public_key_path = "${var.public_key_path}"
  zone            = "${var.zone}"
  db_disk_image   = "${var.db_disk_image}"
}
