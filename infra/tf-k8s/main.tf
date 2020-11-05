provider "yandex" {
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}

resource "yandex_kubernetes_cluster" "crawler-app-cluster" {
  name        = "crawler-app-cluster"
  description = "Kubernetes cluster for crawler-app"

  network_id = var.network_id

  master {
    version = "1.17"
    zonal {
      zone      = var.zone
      subnet_id = var.subnet_id
    }

    public_ip = true

    maintenance_policy {
      auto_upgrade = true

      maintenance_window {
        start_time = "15:00"
        duration   = "3h"
      }
    }
  }

  service_account_id      = var.service_account_id
  node_service_account_id = var.service_account_id

  labels = {

  }

  release_channel = "RAPID"
  network_policy_provider = "CALICO"

}

resource "yandex_kubernetes_node_group" "node-group-0" {
  cluster_id  = yandex_kubernetes_cluster.crawler-app-cluster.id
  name        = "node-group-0"
  version     = "1.17"

  instance_template {
    platform_id = "standard-v2"
    nat         = true

    resources {
      memory = 16
      cores  = 4
    }

    boot_disk {
      type = "network-hdd"
      size = 120
    }

    scheduling_policy {
      preemptible = false
    }
  }

  scale_policy {
    fixed_scale {
      size = 2
    }
  }

  allocation_policy {
    location {
      zone = var.zone
    }
  }

  maintenance_policy {
    auto_upgrade = false
    auto_repair  = true
  }
}


