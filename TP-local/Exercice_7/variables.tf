variable "machines" {
  description = "Liste des machines à créer avec leurs paramètres"
  type = list(object({
    name      = string
    vcpu      = number
    disk_size = number
    region    = string
  }))

  # Condition relative au CPU
  validation {
    condition = alltrue([
      for machine in var.machines : machine.vcpu >= 2 && machine.vcpu <= 64
    ])
    error_message = "vCPU (min. 2, max. 64)"
  }

  # Condition relative à la taille du disque
  validation {
    condition = alltrue([
      for machine in var.machines : machine.disk_size >= 20
    ])
    error_message = "disque (en Go, min. 20)"
  }

  # Confition pour valider la région
  validation {
    condition = alltrue([
      for machine in var.machines : contains(["eu-west-1", "us-east-1", "ap-southeast-1"], machine.region)
    ])
    error_message = "La région doit être l'une des suivantes : eu-west-1, us-east-1, ap-southeast-1."
  }

  default = [
    {
      name      = "machine1"
      vcpu      = 4
      disk_size = 50
      region    = "eu-west-1"
    },
    {
      name      = "machine2"
      vcpu      = 8
      disk_size = 100
      region    = "us-east-1"
    }
  ]
}
