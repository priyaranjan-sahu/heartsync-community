# HeartSync Public Runner Repository Initializer
# Run this script to initialize and publish the public runner repo to your GitHub account.

param(
    [string]$RepoName = "heartsync-runner"
)

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " HeartSync Public Runner Setup: $RepoName" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

$CurrentDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# 1. Initialize git in the public runner directory if not already initialized
if (-not (Test-Path "$CurrentDir\.git")) {
    Write-Host "[1/3] Initializing local Git repository in $CurrentDir..." -ForegroundColor Yellow
    git -C "$CurrentDir" init -b main
    git -C "$CurrentDir" add .
    git -C "$CurrentDir" commit -m "feat: initialize public CI/CD runner bridge for HeartSync"
} else {
    Write-Host "[1/3] Git repository already initialized." -ForegroundColor Green
    git -C "$CurrentDir" add .
    git -C "$CurrentDir" commit -m "chore: update public runner configuration" -q
}

# 2. Check if GitHub CLI is authenticated
Write-Host "`n[2/3] Checking GitHub CLI status..." -ForegroundColor Yellow
$ghAuth = gh auth status 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "GitHub CLI is authenticated. Creating public repository '$RepoName'..." -ForegroundColor Green
    gh repo create $RepoName --public --source="$CurrentDir" --remote=origin --push
    Write-Host "✔ Public repository created and pushed successfully: https://github.com/priyaranjan-sahu/$RepoName" -ForegroundColor Green
} else {
    Write-Host "GitHub CLI is not currently logged in or token is expired." -ForegroundColor Yellow
    Write-Host "To create and push the repository manually:" -ForegroundColor Cyan
    Write-Host "  1. Run: gh auth login" -ForegroundColor White
    Write-Host "  2. Run: gh repo create $RepoName --public --source=`"$CurrentDir`" --remote=origin --push" -ForegroundColor White
    Write-Host "`nOr create an empty repository named '$RepoName' on https://github.com/new and run:" -ForegroundColor Cyan
    Write-Host "  git -C `"$CurrentDir`" remote add origin https://github.com/priyaranjan-sahu/$RepoName.git" -ForegroundColor White
    Write-Host "  git -C `"$CurrentDir`" push -u origin main" -ForegroundColor White
}

Write-Host "`n[3/3] Next Steps:" -ForegroundColor Cyan
Write-Host "  - In https://github.com/priyaranjan-sahu/$RepoName/settings/secrets/actions" -ForegroundColor White
Write-Host "  - Add Secret: PRIVATE_REPO_TOKEN (Your GitHub Personal Access Token with read access to priyaranjan-sahu/heartsync)" -ForegroundColor White
Write-Host "==========================================================" -ForegroundColor Cyan
