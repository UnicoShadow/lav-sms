# LAV SMS - Quick Fix Script
# Run this in PowerShell: .\fix.ps1
# Or: powershell -ExecutionPolicy Bypass -File fix.ps1

Write-Host "============================================" -ForegroundColor Green
Write-Host "   LAV SMS - Quick Fix Script" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Green
Write-Host ""

# Step 1: Enable ALL required PHP extensions
Write-Host "[1/6] Enabling PHP extensions..." -ForegroundColor Cyan
$phpIni = "C:\xampp\php\php.ini"
$extensions = @('zip', 'gd', 'curl', 'mbstring', 'fileinfo', 'openssl', 'pdo_pgsql', 'pgsql', 'intl', 'exif', 'pdo_mysql', 'mysqli')

$content = Get-Content $phpIni -Raw
foreach ($ext in $extensions) {
    $content = $content -replace ";extension=$ext", "extension=$ext"
}
$content | Set-Content $phpIni
Write-Host "   All extensions enabled!" -ForegroundColor Green
Write-Host ""

# Step 2: Composer install
Write-Host "[2/6] Running composer install (2-5 minutes)..." -ForegroundColor Cyan
composer install --no-interaction
if ($LASTEXITCODE -ne 0) {
    Write-Host "   Retrying with --ignore-platform-reqs..." -ForegroundColor Yellow
    composer install --no-interaction --ignore-platform-reqs
}
Write-Host ""

# Step 3: Create .env
Write-Host "[3/6] Creating .env file..." -ForegroundColor Cyan
if (-not (Test-Path ".env")) {
    Copy-Item ".env.example.supabase" ".env"
    Write-Host "   .env created!" -ForegroundColor Green
} else {
    Write-Host "   .env already exists." -ForegroundColor Yellow
}
Write-Host ""

# Step 4: Generate key
Write-Host "[4/6] Generating app key..." -ForegroundColor Cyan
php artisan key:generate
Write-Host ""

# Step 5: Storage link + cache clear
Write-Host "[5/6] Setting up storage and clearing cache..." -ForegroundColor Cyan
php artisan storage:link
php artisan config:clear
php artisan cache:clear
php artisan view:clear
Write-Host ""

# Step 6: Start server
Write-Host "[6/6] Starting server..." -ForegroundColor Cyan
Write-Host ""
Write-Host "============================================" -ForegroundColor Green
Write-Host "   Open http://localhost:8000 in browser" -ForegroundColor Green
Write-Host "   Login: admin@lavsms.com / cj" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Green
Write-Host ""
php artisan serve
