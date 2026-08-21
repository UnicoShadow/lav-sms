@echo off
title LAV SMS - Complete Setup Script
color 0A
echo ============================================
echo    LAV SMS - AUTOMATIC SETUP SCRIPT
echo ============================================
echo.

REM ============================================
REM STEP 1: Enable PHP extensions in php.ini
REM ============================================
echo [STEP 1/8] Enabling PHP extensions...

set "PHPINI=C:\xampp\php\php.ini"

REM Enable zip extension (needed by Composer)
powershell -Command "(Get-Content '%PHPINI%') -replace ';extension=zip', 'extension=zip' | Set-Content '%PHPINI%'"
REM Enable gd extension
powershell -Command "(Get-Content '%PHPINI%') -replace ';extension=gd', 'extension=gd' | Set-Content '%PHPINI%'"
REM Enable curl extension
powershell -Command "(Get-Content '%PHPINI%') -replace ';extension=curl', 'extension=curl' | Set-Content '%PHPINI%'"
REM Enable mbstring extension
powershell -Command "(Get-Content '%PHPINI%') -replace ';extension=mbstring', 'extension=mbstring' | Set-Content '%PHPINI%'"
REM Enable fileinfo extension
powershell -Command "(Get-Content '%PHPINI%') -replace ';extension=fileinfo', 'extension=fileinfo' | Set-Content '%PHPINI%'"
REM Enable openssl extension
powershell -Command "(Get-Content '%PHPINI%') -replace ';extension=openssl', 'extension=openssl' | Set-Content '%PHPINI%'"
REM Enable pdo_pgsql extension (for Supabase PostgreSQL)
powershell -Command "(Get-Content '%PHPINI%') -replace ';extension=pdo_pgsql', 'extension=pdo_pgsql' | Set-Content '%PHPINI%'"
REM Enable pgsql extension
powershell -Command "(Get-Content '%PHPINI%') -replace ';extension=pgsql', 'extension=pgsql' | Set-Content '%PHPINI%'"
REM Enable intl extension
powershell -Command "(Get-Content '%PHPINI%') -replace ';extension=intl', 'extension=intl' | Set-Content '%PHPINI%'"
REM Enable exif extension
powershell -Command "(Get-Content '%PHPINI%') -replace ';extension=exif', 'extension=exif' | Set-Content '%PHPINI%'"

echo    Done! All PHP extensions enabled.
echo.

REM ============================================
REM STEP 2: Install Composer dependencies
REM ============================================
echo [STEP 2/8] Installing Composer dependencies...
echo    This may take 2-5 minutes. Please wait...
echo.
call composer install --no-interaction
if %errorlevel% neq 0 (
    echo.
    echo    ERROR: Composer install failed. Trying with --ignore-platform-reqs...
    call composer install --no-interaction --ignore-platform-reqs
)
echo.
echo    Done! Dependencies installed.
echo.

REM ============================================
REM STEP 3: Create .env file
REM ============================================
echo [STEP 3/8] Creating .env file...
if not exist ".env" (
    copy ".env.example.supabase" ".env" >nul
    echo    Created .env from .env.example.supabase
) else (
    echo    .env already exists. Skipping.
)
echo.

REM ============================================
REM STEP 4: Generate Application Key
REM ============================================
echo [STEP 4/8] Generating application key...
call php artisan key:generate
echo.

REM ============================================
REM STEP 5: Create Storage Link
REM ============================================
echo [STEP 5/8] Creating storage link...
call php artisan storage:link
echo.

REM ============================================
REM STEP 6: Clear All Caches
REM ============================================
echo [STEP 6/8] Clearing caches...
call php artisan config:clear
call php artisan cache:clear
call php artisan view:clear
call php artisan route:clear
echo.

REM ============================================
REM STEP 7: Create storage directories
REM ============================================
echo [STEP 7/8] Creating storage directories...
if not exist "storage\app\public" mkdir "storage\app\public"
if not exist "storage\framework\cache\data" mkdir "storage\framework\cache\data"
if not exist "storage\framework\sessions" mkdir "storage\framework\sessions"
if not exist "storage\framework\views" mkdir "storage\framework\views"
if not exist "storage\logs" mkdir "storage\logs"
echo.

REM ============================================
REM STEP 8: Start the Server
REM ============================================
echo [STEP 8/8] Starting Laravel server...
echo.
echo ============================================
echo    SETUP COMPLETE!
echo ============================================
echo.
echo    Server starting at: http://localhost:8000
echo.
echo    Login with:
echo    Email:    admin@lavsms.com
echo    Password: cj
echo.
echo    IMPORTANT: If you haven't set your
echo    Supabase DB password in .env yet,
echo    press Ctrl+C, edit .env, then run:
echo    php artisan serve
echo.
echo ============================================
echo.
call php artisan serve
pause
