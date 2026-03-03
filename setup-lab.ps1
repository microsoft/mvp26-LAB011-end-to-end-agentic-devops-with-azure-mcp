<#
.SYNOPSIS
    MCP Lab - Prerequisite Installer & Validator
    "Ship, Harden, Break, Investigate - Azure DevOps with AI as Your Co-Pilot"

.DESCRIPTION
    Installs all prerequisites for the MVP Summit hands-on lab via winget,
    then validates everything is ready. Run from an elevated PowerShell prompt.

.NOTES
    Requires: Windows 10/11 with winget available
    Run as:   powershell -ExecutionPolicy Bypass -File setup-lab.ps1
#>

param(
    [switch]$ValidateOnly  # Skip installs, just check what's ready
)

$ErrorActionPreference = "Continue"

# ── Helpers ──────────────────────────────────────────────────────────────────

function Write-Step  { param($msg) Write-Host "`n▶ $msg" -ForegroundColor Cyan }
function Write-Pass  { param($msg) Write-Host "  ✅ $msg" -ForegroundColor Green }
function Write-Fail  { param($msg) Write-Host "  ❌ $msg" -ForegroundColor Red }
function Write-Warn  { param($msg) Write-Host "  ⚠️  $msg" -ForegroundColor Yellow }
function Write-Info  { param($msg) Write-Host "  ℹ️  $msg" -ForegroundColor Gray }

$script:passed = 0
$script:failed = 0
$script:warnings = 0

function Test-Command {
    param($Name, $Command, $MinVersion)
    try {
        $output = Invoke-Expression $Command 2>$null
        if ($LASTEXITCODE -ne 0 -and $null -eq $output) { throw "not found" }
        Write-Pass "$Name - $output"
        $script:passed++
        return $true
    } catch {
        Write-Fail "$Name - not found"
        $script:failed++
        return $false
    }
}

# ── Installation (skip with -ValidateOnly) ───────────────────────────────────

if (-not $ValidateOnly) {
    Write-Host "`n╔══════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║  MCP Lab - Installing Prerequisites                     ║" -ForegroundColor Cyan
    Write-Host "╚══════════════════════════════════════════════════════════╝" -ForegroundColor Cyan

    # Check for winget
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        Write-Fail "winget not found. Please install App Installer from the Microsoft Store."
        exit 1
    }

    Write-Step "Installing Git"
    winget install --id Git.Git -e --accept-source-agreements --accept-package-agreements --silent 2>&1 | Out-Null
    # Refresh PATH for git
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")

    Write-Step "Installing Node.js 22 LTS"
    winget install --id OpenJS.NodeJS.LTS -e --accept-source-agreements --accept-package-agreements --silent 2>&1 | Out-Null
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")

    Write-Step "Installing Docker Desktop"
    winget install --id Docker.DockerDesktop -e --accept-source-agreements --accept-package-agreements --silent 2>&1 | Out-Null
    Write-Info "Docker Desktop may require a restart and manual launch after install."

    Write-Step "Installing Azure CLI"
    winget install --id Microsoft.AzureCLI -e --accept-source-agreements --accept-package-agreements --silent 2>&1 | Out-Null
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")

    Write-Step "Installing Azure Developer CLI (azd)"
    winget install --id Microsoft.Azd -e --accept-source-agreements --accept-package-agreements --silent 2>&1 | Out-Null
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")

    Write-Step "Installing Bicep"
    az bicep install 2>&1 | Out-Null

    Write-Step "Installing Azure CLI extensions"
    az config set extension.dynamic_install_allow_preview=true 2>&1 | Out-Null
    az extension add --name scheduled-query --yes 2>&1 | Out-Null

    Write-Step "Installing VS Code Insiders (optional - for Mermaid preview)"
    winget install --id Microsoft.VisualStudioCode.Insiders -e --accept-source-agreements --accept-package-agreements --silent 2>&1 | Out-Null

    Write-Host "`n━━━ Installation complete. Running validation... ━━━" -ForegroundColor Cyan
}

# ── Validation ───────────────────────────────────────────────────────────────

Write-Host "`n╔══════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  MCP Lab - Prerequisite Validation                      ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════════════════════╝" -ForegroundColor Cyan

# 1. Git
Write-Step "Git"
Test-Command "Git" "git --version" | Out-Null

# 2. Node.js
Write-Step "Node.js 22 or later"
$nodeOk = Test-Command "Node.js" "node -v"
if ($nodeOk) {
    $nodeVer = (node -v) -replace 'v', ''
    $major = [int]($nodeVer.Split('.')[0])
    if ($major -lt 22) {
        Write-Warn "Node.js $nodeVer found but 22+ recommended. Run: winget upgrade OpenJS.NodeJS.LTS"
        $script:warnings++
    }
}

# 3. Docker
Write-Step "Docker Desktop"
$dockerOk = Test-Command "Docker CLI" "docker --version"
if ($dockerOk) {
    $serverOk = $false
    try {
        $sv = docker version --format "{{.Server.Version}}" 2>$null
        if ($LASTEXITCODE -eq 0 -and $sv) {
            Write-Pass "Docker Engine running - $sv"
            $script:passed++
            $serverOk = $true
        }
    } catch {}
    if (-not $serverOk) {
        Write-Fail "Docker Engine not running - start Docker Desktop before the lab"
        $script:failed++
    }
}

# 4. Azure CLI
Write-Step "Azure CLI"
try {
    $azVer = az version -o json 2>$null | ConvertFrom-Json
    if ($azVer) {
        $cliVer = $azVer.'azure-cli'
        Write-Pass "Azure CLI - $cliVer"
        $script:passed++
        $azOk = $true
    } else { throw "not found" }
} catch {
    Write-Fail "Azure CLI - not found. Run: winget install Microsoft.AzureCLI"
    $script:failed++
    $azOk = $false
}
if ($azOk) {
    # Bicep
    $bicepVer = az bicep version 2>$null
    if ($LASTEXITCODE -eq 0) { Write-Pass "Bicep - $bicepVer"; $script:passed++ }
    else { Write-Fail "Bicep not installed. Run: az bicep install"; $script:failed++ }
}

# 5. Azure Developer CLI
Write-Step "Azure Developer CLI (azd)"
Test-Command "azd" "azd version" | Out-Null

# 6. Azure CLI extensions
Write-Step "Azure CLI Extensions"
try {
    $sqVer = az extension show --name scheduled-query --query version -o tsv 2>$null
    if ($sqVer) { Write-Pass "scheduled-query extension - v$sqVer"; $script:passed++ }
    else { throw "not found" }
} catch {
    Write-Fail "scheduled-query extension not installed. Run: az extension add --name scheduled-query --yes"
    $script:failed++
}

# 7. Azure login
Write-Step "Azure Subscription"
try {
    $subName = az account show --query name -o tsv 2>$null
    if ($LASTEXITCODE -eq 0 -and $subName) {
        Write-Pass "Logged in - subscription: $subName"
        $script:passed++

        # Check Contributor access
        $roleCheck = az role assignment list --assignee (az ad signed-in-user show --query id -o tsv 2>$null) --query "[?roleDefinitionName=='Contributor' || roleDefinitionName=='Owner'].roleDefinitionName" -o tsv 2>$null
        if ($roleCheck) { Write-Pass "Role: $($roleCheck | Select-Object -First 1)"; $script:passed++ }
        else { Write-Warn "Could not verify Contributor/Owner role. Ensure you have Contributor access."; $script:warnings++ }
    } else { throw "not logged in" }
} catch {
    Write-Fail "Not logged in. Run: az login"
    $script:failed++
}

# 8. GitHub Copilot CLI (best-effort check)
Write-Step "GitHub Copilot CLI"
try {
    $ghCopilot = Get-Command ghcs -ErrorAction SilentlyContinue
    if (-not $ghCopilot) { $ghCopilot = Get-Command "github-copilot-cli" -ErrorAction SilentlyContinue }
    if ($ghCopilot) { Write-Pass "GitHub Copilot CLI found"; $script:passed++ }
    else { throw "not found" }
} catch {
    Write-Warn "GitHub Copilot CLI not detected via PATH. Ensure it's installed and Azure MCP is enabled."
    $script:warnings++
}

# ── Summary ──────────────────────────────────────────────────────────────────

Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "  Results: $($script:passed) passed, $($script:failed) failed, $($script:warnings) warnings" -ForegroundColor $(if ($script:failed -gt 0) { "Red" } else { "Green" })
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan

if ($script:failed -gt 0) {
    Write-Host "`n  ⛔ Fix the failures above before starting the lab." -ForegroundColor Red
    Write-Host "  Re-run with: .\setup-lab.ps1 -ValidateOnly`n" -ForegroundColor Gray
    exit 1
} elseif ($script:warnings -gt 0) {
    Write-Host "`n  ⚠️  Warnings found - lab may still work but check the items above." -ForegroundColor Yellow
    exit 0
} else {
    Write-Host "`n  🚀 All prerequisites met. You're ready for the lab!`n" -ForegroundColor Green
    exit 0
}
