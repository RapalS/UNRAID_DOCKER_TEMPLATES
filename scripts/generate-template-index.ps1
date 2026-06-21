#Requires -Version 5.1
<#
.SYNOPSIS
    Regenerate docs/TEMPLATE_INDEX.md from templates/*.xml
#>
[CmdletBinding()]
param(
    [switch]$Check
)

$ErrorActionPreference = "Stop"
$RepoRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$Args = @("$RepoRoot\scripts\generate_template_index.py", "--repo-root", $RepoRoot)
if ($Check) { $Args += "--check" }
& python @Args
exit $LASTEXITCODE
