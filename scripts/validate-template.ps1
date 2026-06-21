#Requires -Version 5.1
<#
.SYNOPSIS
    Validate Unraid Docker template XML files (Windows).

.EXAMPLE
    .\scripts\validate-template.ps1 templates\nornicdb-hermes-memory-cpu.xml

.EXAMPLE
    .\scripts\validate-template.ps1 -Strict
#>
[CmdletBinding()]
param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$Paths = @("templates", "examples", "ca_profile.xml"),

    [switch]$Strict
)

$ErrorActionPreference = "Stop"
$RepoRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$ValidatePy = Join-Path $RepoRoot "scripts\validate.py"

if (-not (Test-Path $ValidatePy)) {
    Write-Error "validate.py not found at $ValidatePy"
}

$args = @($ValidatePy, "--repo-root", $RepoRoot)
if ($Strict) { $args += "--strict" }
if ($Paths) { $args += $Paths }

& python @args
exit $LASTEXITCODE
