param(
    [Parameter(Mandatory = $true)]
    [string]$FilePath,

    [Parameter(Mandatory = $true)]
    [string]$Title,

    [Parameter(Mandatory = $true)]
    [string]$Description,

    [Parameter(Mandatory = $true)]
    [string]$Creators
)

$token = $env:ZENODO_TOKEN
if (-not $token) {
    Write-Error "ZENODO_TOKEN environment variable is not set."
    Write-Host "Example: $env:ZENODO_TOKEN = 'YOUR_TOKEN'"
    exit 1
}

if (-not (Test-Path $FilePath)) {
    Write-Error "File not found: $FilePath"
    exit 1
}

$headers = @{ Authorization = "Bearer $token" }

$metadata = @{
    metadata = @{
        title       = $Title
        upload_type = "software"
        description = $Description
        creators    = @(
            @{ name = $Creators }
        )
    }
}

Write-Host "Creating Zenodo deposition..."
$deposition = Invoke-RestMethod -Method Post -Uri "https://zenodo.org/api/deposit/depositions" -Headers $headers -ContentType "application/json" -Body ($metadata | ConvertTo-Json -Depth 10)

$bucketUrl = $deposition.links.bucket
if (-not $bucketUrl) {
    Write-Error "Could not get upload bucket from Zenodo response."
    exit 1
}

$fileName = [System.IO.Path]::GetFileName($FilePath)
$uploadUrl = "$bucketUrl/$fileName"

Write-Host "Uploading file to Zenodo..."
Invoke-RestMethod -Method Put -Uri $uploadUrl -Headers $headers -InFile $FilePath -ContentType "application/octet-stream"

Write-Host "Upload completed. Deposition ID: $($deposition.id)"
Write-Host "Review and publish at: $($deposition.links.html)"
