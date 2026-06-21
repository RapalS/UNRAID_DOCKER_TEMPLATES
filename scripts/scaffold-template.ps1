#Requires -Version 5.1
<#
.SYNOPSIS
    Scaffold a new Unraid Docker template from docs/examples/scaffold-starter.xml.example.

.PARAMETER Name
    App slug (lowercase, hyphenated), e.g. my-cool-app

.PARAMETER Image
    Docker image reference, e.g. ghcr.io/org/app:latest

.PARAMETER Category
    CA category string, default Tools:Utilities

.PARAMETER Port
    Primary web port for WebUI token, default 8080

.EXAMPLE
    .\scripts\scaffold-template.ps1 -Name "sonarr" -Image "lscr.io/linuxserver/sonarr:latest" -Port 8989
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$Name,

    [Parameter(Mandatory = $true)]
    [string]$Image,

    [string]$Category = "Tools:Utilities",

    [int]$Port = 8080,

    [string]$Username = "RapalS",

    [string]$Project = "https://github.com/UPSTREAM/REPO"
)

$ErrorActionPreference = "Stop"

if ($Name -notmatch '^[a-z0-9]+(-[a-z0-9]+)*$') {
    Write-Error "Name must be lowercase hyphenated slug (e.g. my-app)"
}

$RepoRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$TemplateSrc = Join-Path $RepoRoot "docs\examples\scaffold-starter.xml.example"
$TemplateDst = Join-Path $RepoRoot "templates\$Name.xml"
$DocDir = Join-Path $RepoRoot "docs\apps"
$DocDst = Join-Path $DocDir "$Name.md"

if (-not (Test-Path $TemplateSrc)) {
    Write-Error "Starter template not found: $TemplateSrc"
}

if (Test-Path $TemplateDst) {
    Write-Error "Template already exists: $TemplateDst"
}

$content = Get-Content $TemplateSrc -Raw
$content = $content -replace 'APP_NAME', $Name
$content = $content -replace 'ghcr\.io/ORG/IMAGE:tag', [regex]::Escape($Image)
$content = $content -replace 'RapalS', $Username
$content = $content -replace 'https://github.com/UPSTREAM/REPO', $Project
$content = $content -replace '\[PORT:8080\]', "[PORT:$Port]"
$content = $content -replace 'Target="8080"', "Target=`"$Port`""
$content = $content -replace 'Default="8080"', "Default=`"$Port`""
$content = $content -replace '>8080</Config>', ">$Port</Config>"
$content = $content -replace '<Category>Tools:Utilities</Category>', "<Category>$Category</Category>"

# Remove optional comment blocks from copied starters
$content = $content -replace '(?s)<!--\s*COPY-PASTE STARTER.*?-->\r?\n', ''

Set-Content -Path $TemplateDst -Value $content -Encoding UTF8
Write-Host "Created: $TemplateDst"
Write-Host "Set <Icon> to the app's upstream raw PNG URL (e.g. https://raw.githubusercontent.com/<owner>/<repo>/main/icon.png)"

New-Item -ItemType Directory -Force -Path $DocDir | Out-Null
if (-not (Test-Path $DocDst)) {
    $docLines = @(
        "# $Name",
        "",
        "Optional per-app setup notes for the Unraid template.",
        "",
        "## Image",
        "",
        "``$Image``",
        "",
        "## Install",
        "",
        "1. Add this repository under Docker -> Docker Repositories, or copy ``templates/$Name.xml`` to flash.",
        "2. Add Container -> select ``$Name`` template.",
        "3. Apply with defaults unless noted below.",
        "",
        "## Post-install",
        "",
        "API keys, reverse proxy, GPU, etc.",
        "",
        "## Tested",
        "",
        "- Unraid version:",
        "- Test server IP:"
    )
    $docLines | Set-Content -Path $DocDst -Encoding UTF8
    Write-Host "Created: $DocDst"
}

Write-Host ""
Write-Host "Next steps:"
Write-Host "  1. Edit $TemplateDst from upstream documentation"
Write-Host "  2. Set <Icon> to the app's upstream raw PNG URL"
Write-Host "  3. Run: .\scripts\validate-template.ps1 templates\$Name.xml"
Write-Host "  4. Run: python scripts/generate_template_index.py"
Write-Host "  5. Test on Unraid, then git add + commit + push"
