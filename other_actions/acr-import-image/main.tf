# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.96.0" # Establishes a forced version
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.18.0"
    }
  }

}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id #"!__subscription_id__!"
  client_id       = var.client_id       #"!__client_id__!"
  client_secret   = var.client_secret   #"!__client_secret__!"
  tenant_id       = var.tenant_id       #"!__tenant_id__!"
}

provider "azuread" {
  tenant_id = var.tenant_id #"!__tenant_id__!"
}

# provider "docker" {
#       host = "unix:///var/run/docker.sock"
#       registry_auth {
#               address  = "https://acrtest.azurecr.io"
#               username = "acrtest"
#               password = "4hyrd/hf+ACRApCucP"
#      }
#     }
# resource "docker_registry_image" "helloworld" {
#           provider      = docker
#           name          = docker_image.image.name
#           keep_remotely = true
# }
    
# resource "docker_image" "image" {
#          provider = docker
#          name     = "acrtest.azurecr.io/helloworld:latest"
#          build {
#           context    = "https://github.com/AcordTest/repo.git#branch"
#           dockerfile = "dockerDirinGithub/dockerfile"
#         }
#  }

resource "null_resource" "run_permission_script" {
  triggers = {
     script_hash = sha256("./ImportImages.ps1")
  }

  provisioner "local-exec" {
    command = "./ImportImages.ps1"
    interpreter = ["pwsh", "-Command"]
  }
}