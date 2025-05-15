# Déclaration du provider null (aucun cloud)
terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
  }
}

# Simule le déploiement de machines virtuelles
resource "null_resource" "vm" {
  for_each = { for machine in var.machines : machine.name => machine }

  # deploiement VMm avec commande locale
  provisioner "local-exec" {
    command = "echo 🔧 Création de la machine ${each.value.name} avec ${each.value.vcpu} vCPU, ${each.value.disk_size} Go, en région ${each.value.region}"
  }
}

# output des machines crées
output "machines_deployées" {
  value = [
    for vm in var.machines :
    "✔️ ${vm.name} (${vm.region}) - ${vm.vcpu} vCPU, ${vm.disk_size} Go"
  ]
}