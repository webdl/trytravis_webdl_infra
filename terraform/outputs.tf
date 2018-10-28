output "app_external_ip" {
  value = "${module.app.app_external_ip}"
}

# output "load_balancer_ip" {
#   value = "${google_compute_forwarding_rule.default.ip_address}"
# }

