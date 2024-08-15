resource "azuread_application" "app" {
    display_name     = var.display_name
    owners           = var.owners
    sign_in_audience = var.sign_in_audience
    identifier_uris  = var.need_identifier_uris == true ? var.identifier_uris : []

    api {
        mapped_claims_enabled          = false
        requested_access_token_version = var.api_req_acc_token
    }
    feature_tags {
        enterprise = false
        gallery    = false
    }
    dynamic "required_resource_access" {
        for_each = var.required_resource_access
        content {
            resource_app_id = required_resource_access.value["resource_app_id"]  

            dynamic "resource_access" {
                for_each = required_resource_access.value["resource_access"]
                content {
                    id   = resource_access.value["id"]
                    type = resource_access.value["type"]
                }
            }
        }
    }

    dynamic "single_page_application" {
        for_each =(var.need_single_page_application ? [1] : [0])
        content {
            redirect_uris =  var.single_page_application
        }
    }

    web {
        implicit_grant {
            access_token_issuance_enabled = var.web_access_token #false
            id_token_issuance_enabled     = var.web_id_token #false
        }
    }
}

resource "azuread_application_password" "secret" {
  application_object_id = azuread_application.app.object_id
  display_name          = var.secret_name
}