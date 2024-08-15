

variable "subscription_id" {
  description = "subscription_id"
}
variable "container_registry_name" {
  description = "container_registry_name"
  default = "dryruntemicr"
}

variable "policies" {
  description = "A list of policy assignments"
  type = list(object({
    name                 = string
    policy_definition_id = string
    description          = string
    display_name         = string
    # parameters           = map(any)
  }))
  default = [
    {
      name                 = "Kubernetes-disable-automounting-API-credentials"
      policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/423dd1ba-798e-40e4-9c4d-b6902674b423"
      description          = "Policy is applied or not"
      display_name         = "Kubernetes disable automounting API credentials"
    #   parameters           = {
    #     #     "effect": {
    #     #       "value": "Deny"
    #     #     }
    #      }
    },
    {
      name                 = "Kubernetes-cluster-containers-should-only-use-allowed-images"
      policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/febd0533-8e55-448f-b837-bd0e06f16469"
      description          = "Policy is applied or not"
      display_name         = "Kubernetes cluster containers should only use allowed images"
    #   parameters = {
    #     # "effect": {
    #     #     "value": "Deny"
    #     # },
    #     # "allowedContainerImagesRegex" = {
    #     #   "value" = "[concat('^', var.container_registry_name, '.azurecr.io\\/.+$')]"
    #     # }
    #   }
    },
    {
      name                 = "Kubernetes-cluster-services-should-listen-only-on-allowed-ports"
      policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/233a2a17-77ca-4fb1-9b6b-69223d272a44"
      description          = "Policy is applied or not"
      display_name         = "Kubernetes cluster services should listen only on allowed ports"
    #   parameters           = {
    #     # "effect": {
    #     # "value": "Deny"
    #     # },
    #     # "allowedServicePortsList": {
    #     # "value": ["443","80","4010","4020","4030","4040","4050","4060","4070","4080","4090","4110","4120","4130","5050","5432","587","6379","2424","2480","8080","10254"]
    #     # }
    # }
    },
    {
      name                 = "Kubernetes-should-not-allow-container-privilege-escalation"
      policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/1c6e92c9-99f0-4e55-9cf2-0c234dc48f99"
      description          = "Policy is applied or not"
      display_name         = "Kubernetes should not allow container privilege escalation"
    #   parameters           = {
    #     # "effect": {
    #     #     "value": "Deny"
    #     # }
    #     }
    },
    {
      name                 = "Kubernetes-Pods-should-only-run-with-approved-user-and-group-IDs"
      policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/f06ddb64-5fa3-4b77-b166-acb36f7f6042"
      description          = "Policy is applied or not"
      display_name         = "Kubernetes Pods should only run with approved user and group IDs"
    #   parameters           = {
    #         # "effect": {
    #         #   "value": "Deny"
    #         # },
    #         # "runAsUserRule": {
    #         #   "value": "MustRunAsNonRoot"
    #         # },
    #         # "runAsUserRanges": {
    #         #   "value": {
    #         #       "ranges": [
    #         #         {
    #         #           "min": 1000,
    #         #           "max": 1000
    #         #         },
    #         #         {
    #         #           "min": 5050,
    #         #           "max": 5050
    #         #         },
    #         #         {
    #         #           "min": 101,
    #         #           "max": 101
    #         #         },
    #         #         {
    #         #           "min": 65534,
    #         #           "max": 65534
    #         #         },
    #         #         {
    #         #           "min": 2000,
    #         #           "max": 2000
    #         #         }
    #         #       ]
    #         #     }
    #       },
    #         "fsGroupRule": {
    #           "value": "MustRunAs"
    #         },
    #         "fsGroupRanges": {
    #           "value": {
    #             "ranges": [
    #               {
    #                 "min": 1000,
    #                 "max": 1000
    #               },
    #               {
    #                 "min": 5050,
    #                 "max": 5050
    #               },
    #               {
    #                 "min": 101,
    #                 "max": 101
    #               },
    #               {
    #                 "min": 65534,
    #                 "max": 65534
    #               },
    #               {
    #                 "min": 2000,
    #                 "max": 2000
    #               }
    #             ]
    #           }
    #         }
    #     }
    },
    {
      name                 = "Kubernetes-containers-should-only-use-allowed-capabilities"
      policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/c26596ff-4d70-4e6a-9a30-c2506bd2f80c"
      description          = "Policy is applied or not"
      display_name         = "Kubernetes containers should only use allowed capabilities"
    #   parameters           = {
    #         # "effect": {
    #         #   "value": "Deny"
    #         # },
    #         # "allowedCapabilities": {
    #         #   "value": ["NET_BIND_SERVICE"]
    #         # },
    #         # "requiredDropCapabilities": {
    #         #     "value": ["all","ALL"]
    #         # }
    #     }
    },
    {
      name                 = "Storage-accounts-should-have-the-specified-minimum-TLS-version"
      policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/fe83a0eb-a853-422d-aac2-1bffd182c5d0"
      description          = "Policy is applied or not"
      display_name         = "Storage accounts should have the specified minimum TLS version"
    #   parameters           = {
    #         # "effect": {
    #         #   "value": "Deny"
    #         # },
    #         # "minimumTlsVersion": {
    #         #   "value": "TLS1_2"
    #         # }
    #     }
    },
    {
      name                 = "Kubernetes-should-not-use-the-default-namespace"
      policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/9f061a12-e40d-4183-a00e-171812443373"
      description          = "Policy is applied or not"
      display_name         = "Kubernetes should not use the default namespace"
    #   parameters           = {
    #         # "effect": {
    #         #   "value": "Deny"
    #         # }
    #     }
    },
    {
      name                 = "Containers-should-run-with-a-read-only-root-file-system"
      policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/df49d893-a74c-421d-bc95-c663042e5b80"
      description          = "Policy is applied or not"
      display_name         = "Containers should run with a read only root file system"
    #   parameters           = {
    #         # "effect": {
    #         #   "value": "Deny"
    #         # },
    #         # "excludedContainers": {
    #         #   "value": ["content-processing-api","intelinotion-pleasereview-api","intelinotion-document-processing-service","controller","intelinotion-pgadmin","intelinotion-pginit"]
    #         # }
    #     }
    }
   
  ]
}
