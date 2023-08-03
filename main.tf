terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "crashloopbackoff_on_kubernetes_pod" {
  source    = "./modules/crashloopbackoff_on_kubernetes_pod"

  providers = {
    shoreline = shoreline
  }
}