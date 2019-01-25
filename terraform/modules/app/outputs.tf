output "ids" {
  value = "${google_compute_instance.app.*.id}"
}

output "external_ip" {
  value = "${google_compute_instance.app.*.network_interface.0.access_config.0.assigned_nat_ip}"
}
