#This scripts reads the config.json file. Login azure and set the default subscription. 
$secret = "Xok23532"
$clientId = "ttiamiyu@arborsys.com"
$imageConfigFilePath = "config.json"
$imageConfigDataFile = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($PSScriptRoot, $imageConfigFilePath))
$config = Get-Content -Raw -Path $imageConfigDataFile | ConvertFrom-Json

# az login --tenant $config.targetTenant --out table
az login --service-principal --username $clientId --password $secret --tenant $config.targetTenant --output none
az account set --subscription $config.targetSubscriptionId
az acr login -n $config.targetRepositoryName

Write-Output "Enabling Admin access to ACR"
az acr update -n $config.targetRepositoryName --admin-enabled true --resource-group $config.targetResourceGroup
$images = @();

$serverName = $config.sourceLoginServer;
for ($i=0; $i -lt $config.sourceImages.length; $i++) {
	$imageName = $config.sourceImages[$i];
    $sourceRepositoryPath = -join($serverName,"/", $imageName);
    Write-Output 'Importing image ' $sourceRepositoryPath
    $targetRepositoryTag = -join($config.targetImagePrefix,"/", $imageName)
    az acr import --resource-group $config.targetResourceGroup --name $config.targetRepositoryName --source $sourceRepositoryPath --image $targetRepositoryTag --repository $config.sourceRepositoryName --username $config.sourceServerAdminUser --password $config.sourceServerPassword
    Write-Output 'Image imported at ' $targetRepositoryTag
    $images += $config.targetRepositoryName.ToLower() + ".azurecr.io/" + $targetRepositoryTag
}
Write-Output 'Image import process completed';

$imageRef = @(
    [PSObject]@{name="{intelinotionWebApi}"; refrenceValue="web-api"},
    [PSObject]@{name="{contentProcessingApi}"; refrenceValue="content-processing-api"},
    [PSObject]@{name="{intelinotionNotificationService}"; refrenceValue="notification-service"},
    [PSObject]@{name="{intelinotionSearchApi}"; refrenceValue="search-api"},
    [PSObject]@{name="{intelinotionClientApp}"; refrenceValue="client-app"},
    [PSObject]@{name="{intelinotionTaskManagementService}"; refrenceValue="task-management-service"},
    [PSObject]@{name="{intelinotionJobApi}"; refrenceValue="job-api"},
    [PSObject]@{name="{intelinotionAuthApi}"; refrenceValue="auth-api"},
    [PSObject]@{name="{intelinotionConnectorApi}"; refrenceValue="connector-api"},
    [PSObject]@{name="{intelinotionDocumentProcessingService}"; refrenceValue="document-processing-service"},
    [PSObject]@{name="{inRedis}"; refrenceValue="redis"},
    [PSObject]@{name="{orientdbservice}"; refrenceValue="orientdb"},
    [PSObject]@{name="{intelinotionDossierService}"; refrenceValue="dossier-service"},
    [PSObject]@{name="{intelinotionPleasereviewApi}"; refrenceValue="pleasereview-api"}
);
$imageRef2 = @(
    [PSObject]@{name="{ingressController}"; refrenceValue="controller"},
    [PSObject]@{name="{ingressAdmissionWebhook}"; refrenceValue="kube-webhook"},
    [PSObject]@{name="{ingressDefaultBackend}"; refrenceValue="defaultbackend"}
);

$paramFileLocation = "..\arm\auto-update-parameters.json";
$paramFileRootLocation = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($PSScriptRoot, $paramFileLocation))
if(Test-Path $paramFileRootLocation){
    Write-Output "Updating ACR image URL's to [auto-update-parameters.json] file in arm folder";
    $paramFile = Get-Content -Raw -Path $paramFileRootLocation | ConvertFrom-Json
    foreach($obj in $imageRef) {
        $imageName = $($images -match $obj.refrenceValue).ToString();
        $index = $paramFile.name.IndexOf($obj.name);
        $paramFile[$index].value = $imageName;
    }
    ## ingress images
    foreach($obj in $imageRef2) {
        $imageName = $($images -match $obj.refrenceValue).ToString();
        $imageName = ($imageName -split ":")[0]
        $index = $paramFile.name.IndexOf($obj.name);
        $paramFile[$index].value = $imageName;
    }  
    $jsonData = $paramFile | ConvertTo-Json
    Set-Content -Path $paramFileRootLocation -Value $jsonData
    Write-Output "Updated ACR images URL's to [auto-update-parameters.json] file in arm folder";
} else {
    Write-Output "Please update ACR image URL's to [auto-update-parameters.json] file in arm folder";
    Write-Output "Refer [ACR Secrets and Image URL's] section of Appendix";
    "imageURL:" > imageURL.yaml;
    foreach ($obj in $imageRef) {
        "  $($obj.name.replace('{','').replace('}','')): $($images -match $obj.refrenceValue)" >> imageURL.yaml;
    }
    Write-Output $(Get-Content -Raw .\imageURL.yaml);
}