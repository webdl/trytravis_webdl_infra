terraform {
  backend "gcs" {
    bucket = "webdl-tf-state"
    prefix = "terraform/stage"
  }
}
