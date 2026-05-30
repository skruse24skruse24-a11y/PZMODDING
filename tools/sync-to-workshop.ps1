param(
    [string]$WorkspaceRoot = (Split-Path -Parent $PSScriptRoot),
    [string]$WorkshopModFolderName = "UndeadEvolutionProject",
    [string]$WorkshopRoot = "$env:USERPROFILE\Zomboid\Workshop",
    [switch]$Clean
)

$ErrorActionPreference = "Stop"

$sourceContents = Join-Path $WorkspaceRoot "Contents"
$targetModRoot = Join-Path $WorkshopRoot $WorkshopModFolderName
$targetContents = Join-Path $targetModRoot "Contents"

if (-not (Test-Path $sourceContents)) {
    throw "Source Contents folder was not found: $sourceContents"
}

if (-not (Test-Path $WorkshopRoot)) {
    New-Item -ItemType Directory -Path $WorkshopRoot -Force | Out-Null
}

if ($Clean -and (Test-Path $targetModRoot)) {
    Remove-Item -Recurse -Force $targetModRoot
}

if (-not (Test-Path $targetModRoot)) {
    New-Item -ItemType Directory -Path $targetModRoot -Force | Out-Null
}

# Mirror the mod payload into Workshop/<ModName>/Contents
Copy-Item -Path $sourceContents -Destination $targetContents -Recurse -Force

Write-Host "Synced mod payload to: $targetModRoot"
Write-Host "Copied: $sourceContents -> $targetContents"
