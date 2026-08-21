# 🪟 LAV SMS - Windows Setup Guide (COMPLETE)

## ❌ Your Current Errors & Fixes

| Error | Cause | Fix |
|-------|-------|-----|
| `'composer' is not recognized` | Composer not installed | Install Composer (Step 2 below) |
| `'php' is not recognized` | PHP not installed | Install PHP (Step 1 below) |
| `'cp' is not recognized` | `cp` is Linux command | Use `copy` on Windows |
| `README.md / readme.md collision` | Case-insensitive filesystem | ✅ **FIXED** - deleted duplicate |

---

## 📥 Step 1: Install PHP on Windows

### Option A: Using XAMPP (Easiest)
1. Download XAMPP from: https://www.apachefriends.org/
2. Install it (default location: `C:\xampp`)
3. PHP will be at: `C:\xampp\php\php.exe`

### Option B: Standalone PHP
1. Download PHP 8.1 from: https://windows.php.net/download/
   - Choose **VS16 x64 Thread Safe** (ZIP file)
2. Extract to `C:\php`
3. Edit `C:\php\php.ini-development`:
   - Rename it to `php.ini`
   - Uncomment these lines (remove the `;`):
     ```ini
     extension_dir = "ext"
     extension=pdo_pgsql
     extension=pgsql
     extension=openssl
     extension=mbstring
     extension=fileinfo
     extension=gd
     extension=curl
     extension=zip
     extension=intl
     ```

### Add PHP to PATH:
1. Press `Windows Key + S` → Search "Environment Variables"
2. Click "Edit the system environment variables"
3. Click "Environment Variables" button
4. Under "System variables" → Find `Path` → Click "Edit"
5. Click "New" → Add: `C:\xampp\php` (or `C:\php` if standalone)
6. Click OK on all dialogs
7. **CLOSE and REOPEN** your Command Prompt!

### Verify PHP:
```cmd
php -v
```
Should show: `PHP 8.1.x` or similar

---

## 📥 Step 2: Install Composer on Windows

1. Download Composer installer: https://getcomposer.org/Composer-Setup.exe
2. Run the installer
3. When it asks for PHP path, select:
   - `C:\xampp\php\php.exe` (if using XAMPP)
   - `C:\php\php.exe` (if standalone)
4. Complete installation
5. **CLOSE and REOPEN** your Command Prompt!

### Verify Composer:
```cmd
composer --version
```
Should show: `Composer version 2.x.x`

---

## 📥 Step 3: Clone the Repository (Fresh)

Since you had the collision issue, delete the old folder and re-clone:

```cmd
cd C:\Users\muhux\Downloads
rmdir /s /q "Compressed\Lav-sms-main"
git clone https://github.com/UnicoShadow/lav-sms.git
cd lav-sms
```

> If you don't have Git: Download from https://git-scm.com/download/win

---

## 📥 Step 4: Install Dependencies

```cmd
composer install
```

This will take 2-5 minutes. Wait for it to finish.

---

## 📥 Step 5: Create .env File

⚠️ **On Windows, use `copy` NOT `cp`:**

```cmd
copy .env.example.supabase .env
```

---

## 📥 Step 6: Set Database Password

### Get your Supabase password:
1. Go to https://supabase.com/dashboard
2. Open **"UnicoShadow's Project"**
3. Go to **Settings** → **Database**
4. Find **"Connection String"** section
5. You'll see: `postgresql://postgres:[YOUR-PASSWORD]@db.mslydvabhamtjltuseno.supabase.co:5432/postgres`
6. Copy the password

### If you don't know the password:
1. Same page → **"Database Password"** section
2. Click **"Reset database password"**
3. Set a new one and remember it!

### Edit the .env file:
Open `.env` in Notepad:
```cmd
notepad .env
```

Find this line:
```
DB_PASSWORD=YOUR_SUPABASE_DB_PASSWORD_HERE
```

Replace with your actual password:
```
DB_PASSWORD=your_actual_password
```

Save and close Notepad.

---

## 📥 Step 7: Generate App Key

```cmd
php artisan key:generate
```

Should show: `Application key set successfully.`

---

## 📥 Step 8: Create Storage Link

```cmd
php artisan storage:link
```

---

## 📥 Step 9: Clear All Caches

```cmd
php artisan config:clear
php artisan cache:clear
php artisan view:clear
php artisan route:clear
```

---

## 📥 Step 10: Start the Server

```cmd
php artisan serve
```

You should see:
```
Starting Laravel development server: http://127.0.0.1:8000
```

---

## 🌐 Step 11: Open the App

Open your browser and go to: **http://localhost:8000**

### Login with:
| Field | Value |
|-------|-------|
| Email | `admin@lavsms.com` |
| Password | `cj` |

---

## 🐛 Troubleshooting Windows Issues

### "php is not recognized" after install
- Make sure you **closed and reopened** Command Prompt after editing PATH
- Try the full path: `C:\xampp\php\php.exe artisan serve`

### "composer install" fails with extension error
- Edit `php.ini` and make sure these are uncommented:
  ```ini
  extension=pdo_pgsql
  extension=pgsql
  extension=openssl
  extension=mbstring
  extension=fileinfo
  extension=gd
  extension=curl
  extension=zip
  extension=intl
  ```

### "could not find driver" error
- This means `pdo_pgsql` extension is not enabled
- Edit `php.ini` → uncomment `extension=pdo_pgsql` and `extension=pgsql`
- Restart the server

### "SSL connection error"
- In `config/database.php`, change `'sslmode' => 'prefer'` to `'sslmode' => 'require'`

### "Permission denied" for storage
- Run Command Prompt as **Administrator**
- Or manually create folders:
  ```cmd
  mkdir storage\app\public
  mkdir storage\framework\cache\data
  mkdir storage\framework\sessions
  mkdir storage\framework\views
  ```

### Port 8000 already in use
- Use a different port: `php artisan serve --port=8080`

### "Class not found" errors
- Run: `composer dump-autoload`

---

## 📋 Quick Command Summary (Copy-Paste Ready)

After installing PHP + Composer, run these ONE BY ONE:

```cmd
cd C:\Users\muhux\Downloads
git clone https://github.com/UnicoShadow/lav-sms.git
cd lav-sms
composer install
copy .env.example.supabase .env
notepad .env
```
*(Edit DB_PASSWORD, save, close Notepad)*
```cmd
php artisan key:generate
php artisan storage:link
php artisan config:clear
php artisan cache:clear
php artisan serve
```

Then open: **http://localhost:8000**

---

## ✅ What's Already Done (No Action Needed)

| Component | Status |
|-----------|--------|
| GitHub Repository | ✅ https://github.com/UnicoShadow/lav-sms |
| Supabase Database (31 tables) | ✅ Created & configured |
| Foreign Keys & Indexes | ✅ Applied |
| Reference Data (states, blood groups, etc.) | ✅ Seeded |
| Admin User | ✅ Created |
| App Settings | ✅ Seeded |
| README collision | ✅ Fixed |
| .env template | ✅ Pre-configured for Supabase |

---

## 🔗 Important Links

- **GitHub Repo:** https://github.com/UnicoShadow/lav-sms
- **Supabase Dashboard:** https://supabase.com/dashboard
- **PHP Download:** https://windows.php.net/download/
- **XAMPP Download:** https://www.apachefriends.org/
- **Composer Download:** https://getcomposer.org/Composer-Setup.exe
- **Git Download:** https://git-scm.com/download/win
