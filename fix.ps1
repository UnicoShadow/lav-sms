# ============================================================
#  LAV SMS - One-Click Repair & Launch  (Windows / PowerShell)
#  Usage:  powershell -ExecutionPolicy Bypass -File .\fix.ps1
# ============================================================
$ErrorActionPreference = "Continue"

function Say($m,$c="White"){ Write-Host $m -ForegroundColor $c }

Say "============================================" Green
Say "   LAV SMS - Repair & Launch" Green
Say "============================================" Green
Say ""

# ---- Guard: must run from the project root -----------------
if (-not (Test-Path ".\artisan")) {
    Say "ERROR: 'artisan' not found in this folder." Red
    Say "You are in: $(Get-Location)" Yellow
    Say "Run this first, then re-run the script:" Yellow
    Say "   cd C:\Users\$env:USERNAME\Downloads\lav-sms" Cyan
    exit 1
}

# ---- 1. Locate php.ini actually used by CLI PHP ------------
Say "[1/7] Configuring PHP extensions..." Cyan
$phpIni = (php --ini 2>$null | Select-String "Loaded Configuration File").ToString().Split(":",2)[1].Trim()
if (-not (Test-Path $phpIni)) { $phpIni = "C:\xampp\php\php.ini" }
Say "      php.ini: $phpIni" DarkGray

Copy-Item $phpIni "$phpIni.backup" -Force -ErrorAction SilentlyContinue

$needed = @('zip','gd','curl','mbstring','fileinfo','openssl','pdo_pgsql','pgsql','intl','exif')
$lines  = Get-Content $phpIni

# Uncomment any needed extension that is currently commented out
for ($i=0; $i -lt $lines.Count; $i++) {
    foreach ($e in $needed) {
        if ($lines[$i] -match "^\s*;\s*extension\s*=\s*$e\s*$") { $lines[$i] = "extension=$e" }
    }
}

# Remove DUPLICATE enabled lines (this is what caused:
# "PHP Warning: Module openssl is already loaded")
$seen = @{}
$out  = New-Object System.Collections.Generic.List[string]
foreach ($l in $lines) {
    if ($l -match "^\s*extension\s*=\s*([A-Za-z0-9_]+)\s*$") {
        $name = $Matches[1].ToLower()
        if ($seen.ContainsKey($name)) { continue }   # drop duplicate
        $seen[$name] = $true
    }
    $out.Add($l)
}

# Append any extension still missing entirely
foreach ($e in $needed) { if (-not $seen.ContainsKey($e)) { $out.Add("extension=$e") } }

Set-Content -Path $phpIni -Value $out -Encoding ASCII
Say "      Extensions enabled + duplicates removed." Green

# ---- 2. Verify the PostgreSQL driver loaded ----------------
Say "[2/7] Verifying pdo_pgsql driver..." Cyan
$drivers = php -r "echo implode(',', PDO::getAvailableDrivers());" 2>$null
if ($drivers -like "*pgsql*") { Say "      pdo_pgsql loaded. ($drivers)" Green }
else {
    Say "      pdo_pgsql NOT loaded. Drivers: $drivers" Red
    Say "      Ensure C:\xampp\php\ext\php_pdo_pgsql.dll exists." Yellow
}

# ---- 3. Composer dependencies ------------------------------
Say "[3/7] Installing Composer dependencies (2-5 min)..." Cyan
composer config --no-plugins policy.advisories.block false 2>$null | Out-Null
if (-not (Test-Path ".\vendor\autoload.php")) {
    composer install --no-interaction --no-audit
    if (-not (Test-Path ".\vendor\autoload.php")) {
        Say "      Retrying with --ignore-platform-reqs..." Yellow
        composer install --no-interaction --no-audit --ignore-platform-reqs
    }
} else { Say "      vendor/ already present. Skipping." DarkGray }

if (-not (Test-Path ".\vendor\autoload.php")) {
    Say "ERROR: composer install failed - vendor/autoload.php missing." Red
    exit 1
}
Say "      Dependencies installed." Green

# ---- 4. .env ------------------------------------------------
Say "[4/7] Preparing .env..." Cyan
if (-not (Test-Path ".env")) { Copy-Item ".env.example.supabase" ".env" }

# Force the IPv4 pooler settings (direct host is IPv6-only)
$env_txt = Get-Content ".env" -Raw
$env_txt = $env_txt -replace "(?m)^DB_HOST=.*$",     "DB_HOST=aws-0-ap-southeast-1.pooler.supabase.com"
$env_txt = $env_txt -replace "(?m)^DB_PORT=.*$",     "DB_PORT=5432"
$env_txt = $env_txt -replace "(?m)^DB_USERNAME=.*$", "DB_USERNAME=postgres.mslydvabhamtjltuseno"
$env_txt = $env_txt -replace "(?m)^DB_CONNECTION=.*$","DB_CONNECTION=pgsql"
$env_txt = $env_txt -replace "(?m)^DB_DATABASE=.*$", "DB_DATABASE=postgres"
$env_txt = $env_txt -replace "(?m)^APP_ENV=.*$",     "APP_ENV=local"
Set-Content ".env" $env_txt -NoNewline

# ---- 5. Ask for the DB password if still a placeholder ------
if ((Get-Content ".env" -Raw) -match "YOUR_SUPABASE_DB_PASSWORD_HERE") {
    Say ""
    Say "   Supabase database password required." Yellow
    Say "   Get it: supabase.com/dashboard -> your project" Yellow
    Say "           -> Settings -> Database -> Connection string" Yellow
    Say ""
    $pw = Read-Host "   Paste your Supabase DB password"
    if ([string]::IsNullOrWhiteSpace($pw)) { Say "   No password entered. Aborting." Red; exit 1 }
    $e = Get-Content ".env" -Raw
    $e = $e -replace "YOUR_SUPABASE_DB_PASSWORD_HERE", [Regex]::Escape($pw).Replace("\","")
    Set-Content ".env" $e -NoNewline
    Say "      Password saved to .env" Green
}

# ---- 6. Key, storage, caches --------------------------------
Say "[5/7] App key, storage, caches..." Cyan
foreach ($d in @("storage\app\public","storage\framework\cache\data","storage\framework\sessions","storage\framework\views","storage\logs","bootstrap\cache")) {
    if (-not (Test-Path $d)) { New-Item -ItemType Directory -Force -Path $d | Out-Null }
}
php artisan key:generate --force
php artisan storage:link 2>$null
php artisan config:clear; php artisan cache:clear; php artisan view:clear; php artisan route:clear
Say "      Done." Green

# ---- 7. Live DB connectivity test ---------------------------
Say "[6/7] Testing Supabase connection..." Cyan
$test = php -r "require 'vendor/autoload.php'; `$a=require 'bootstrap/app.php'; `$a->make(Illuminate\Contracts\Console\Kernel::class)->bootstrap(); try { `$n=Illuminate\Support\Facades\DB::table('users')->count(); echo 'OK:'.`$n; } catch (Exception `$e) { echo 'FAIL:'.`$e->getMessage(); }" 2>&1

if ($test -like "OK:*") {
    Say "      CONNECTED. users table rows: $($test.Split(':')[1])" Green
} else {
    Say "      CONNECTION FAILED" Red
    Say "      $test" Yellow
    Say ""
    Say "   Most likely: wrong DB_PASSWORD in .env" Yellow
    Say "   Reset it at Supabase -> Settings -> Database," Yellow
    Say "   put it in .env, then re-run this script." Yellow
    exit 1
}

# ---- 8. Serve ------------------------------------------------
Say "[7/7] Starting server..." Cyan
Say ""
Say "============================================" Green
Say "   READY -> http://localhost:8000" Green
Say "   Email:    admin@lavsms.com" Green
Say "   Password: cj" Green
Say "============================================" Green
Say ""
php artisan serve
