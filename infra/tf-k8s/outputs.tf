#output "external_ip_address_crawler_app" {
#  value = yandex_compute_instance.crawler.*.network_interface.0.nat_ip_address
#}