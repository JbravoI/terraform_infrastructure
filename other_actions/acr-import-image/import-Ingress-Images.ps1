#Provide the Ingress helm chart version below as per installation key document
$helmChartVersion = "4.5.2"


$imageConfigFilePath = "config.json"
$imageConfigDataFile = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($PSScriptRoot, $imageConfigFilePath))
$config = Get-Content -Raw -Path $imageConfigDataFile | ConvertFrom-Json

az login --tenant $config.targetTenant --out table
az account set --subscription $config.targetSubscriptionId
az acr login -n $config.targetRepositoryName

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
# helm show values ingress-nginx/ingress-nginx --version $helmChartVersion --jsonpath '{.controller.image.registry}/{.controller.image.image}:{.controller.image.tag}{\"\n\"}{.controller.admissionWebhooks.patch.image.registry}/{.controller.admissionWebhooks.patch.image.image}:{.controller.admissionWebhooks.patch.image.tag}{\"\n\"}{.defaultBackend.image.registry}/{.defaultBackend.image.image}:{.defaultBackend.image.tag}'

$globalRepositoryURL = helm show values ingress-nginx/ingress-nginx --version $helmChartVersion --jsonpath '{.controller.image.registry}'
$controllerImage = helm show values ingress-nginx/ingress-nginx --version $helmChartVersion --jsonpath '{.controller.image.image}:{.controller.image.tag}'
$admissionWebhooksImage = helm show values ingress-nginx/ingress-nginx --version $helmChartVersion --jsonpath '{.controller.admissionWebhooks.patch.image.image}:{.controller.admissionWebhooks.patch.image.tag}'
$defaultBackendImage = helm show values ingress-nginx/ingress-nginx --version $helmChartVersion --jsonpath '{.defaultBackend.image.image}:{.defaultBackend.image.tag}'


try {
    Write-Output "Importing Ingress controller global images to target ACR"
    az acr import --name $config.targetRepositoryName --source "$($globalRepositoryURL)/$($controllerImage)" --image $controllerImage
    az acr import --name $config.targetRepositoryName --source "$($globalRepositoryURL)/$($admissionWebhooksImage)" --image $admissionWebhooksImage
    az acr import --name $config.targetRepositoryName --source "$($globalRepositoryURL)/$($defaultBackendImage)" --image $defaultBackendImage
    Write-Output "==========================================================="
    Write-Output "Images are imported to target ACR, please verify from the azure portal"
    Write-Output "==========================================================="
}
catch {
    Write-Output "============================================================="
    Write-Output "Failed to import the images to target ACR, please check again"
    Write-Output "============================================================="
}