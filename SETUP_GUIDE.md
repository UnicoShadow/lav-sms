# 🚀 LAV SMS - Complete Setup Guide

## ✅ What's Already Done

| Component | Status | Details |
|-----------|--------|---------|
| GitHub Repository | ✅ Complete | https://github.com/UnicoShadow/lav-sms |
| Supabase Database | ✅ Complete | 31 tables, all relationships, seeded data |
| Database Schema | ✅ Complete | All migrations applied to Supabase PostgreSQL |
| Reference Data | ✅ Complete | States, blood groups, nationalities, class types, user types |
| Admin User | ✅ Complete | Super Admin account created |
| App Settings | ✅ Complete | All required settings seeded |

---

## 🔑 ONE THING YOU MUST DO: Set Database Password

Your `.env` file has a **placeholder** for the database password:
```
DB_PASSWORD=YOUR_SUPABASE_DB_PASSWORD_HERE
```

### How to Get Your Supabase Database Password:

1. Go to [Supabase Dashboard](https://supabase.com/dashboard)
2. Select **"UnicoShadow's Project"**
3. Navigate to **Settings** → **Database**
4. Scroll to **"Connection String"** section
5. You'll see the connection string like:
   ```
   postgresql://postgres:[YOUR-PASSWORD]@db.mslydvabhamtjltuseno.supabase.co:5432/postgres
   ```
6. Copy the password (the part between `postgres:` and `@`)

### If You Don't Know Your Password:

You can **reset** it:
1. In Supabase Dashboard → **Settings** → **Database**
2. Find **"Database Password"** section
3. Click **"Reset database password"**
4. Set a new password and copy it

### Then Update Your .env:

Replace `YOUR_SUPABASE_DB_PASSWORD_HERE` with your actual password:
```
DB_PASSWORD=your_actual_password_here
```

---

## 📋 Complete Local Setup Steps

### Prerequisites
- PHP 8.0 or 8.1 (Laravel 8 compatible)
- Composer
- Git

### Step 1: Clone the Repository
```bash
git clone https://github.com/UnicoShadow/lav-sms.git
cd lav-sms
```

### Step 2: Install PHP Dependencies
```bash
composer install
```

### Step 3: Create Your .env File
```bash
cp .env.example.supabase .env
```

### Step 4: Edit .env — Set Database Password
Open `.env` and replace the placeholder:
```env
DB_PASSWORD=YOUR_SUPABASE_DB_PASSWORD_HERE
```
With your actual Supabase database password (see instructions above).

### Step 5: Generate Application Key
```bash
php artisan key:generate
```

### Step 6: Create Storage Link
```bash
php artisan storage:link
```

### Step 7: Clear Cache (Important!)
```bash
php artisan config:clear
php artisan cache:clear
php artisan view:clear
```

### Step 8: Start the Server
```bash
php artisan serve
```

### Step 9: Login
Open http://localhost:8000 and login with:
- **Email:** `admin@lavsms.com`
- **Password:** `cj`

---

## 🗄️ Database Connection Details

| Setting | Value |
|---------|-------|
| Driver | PostgreSQL (pgsql) |
| Host | `db.mslydvabhamtjltuseno.supabase.co` |
| Port | `5432` |
| Database | `postgres` |
| Username | `postgres` |
| Password | ⚠️ **You must set this** (see above) |
| SSL Mode | `prefer` (already configured) |

---

## 🔐 Default Login Credentials

| Role | Email | Password |
|------|-------|----------|
| Super Admin | `admin@lavsms.com` | `cj` |

> ⚠️ **IMPORTANT:** Change the default password immediately after first login!
> Go to: My Account → Change Password

---

## 📊 Database Tables (31 Total)

### Core Tables
- `users` — All users (admins, teachers, students, parents)
- `password_resets` — Password reset tokens
- `settings` — Application settings
- `migrations` — Laravel migration tracking

### Academic Structure
- `my_classes` — Classes
- `sections` — Class sections
- `subjects` — Subjects per class
- `class_types` — Class type categories (Primary, Secondary, etc.)
- `dorms` — Dormitories

### People Records
- `student_records` — Student enrollment data
- `staff_records` — Staff employment data
- `user_types` — User role types

### Exams & Marks
- `exams` — Exam definitions
- `marks` — Student marks per subject
- `grades` — Grading scale
- `exam_records` — Exam summary records
- `skills` — Skill assessments
- `pins` — Result checking pins

### Finance
- `payments` — Payment definitions
- `payment_records` — Student payment records
- `receipts` — Payment receipts

### Library
- `books` — Book catalog
- `book_requests` — Book borrowing requests

### Timetable
- `time_table_records` — Timetable definitions
- `time_slots` — Time slot definitions
- `time_tables` — Timetable entries

### Other
- `promotions` — Student promotions
- `blood_groups` — Blood group reference
- `states` — Nigerian states
- `lgas` — Local government areas
- `nationalities` — Nationality reference

---

## 🐛 Troubleshooting

### "Connection refused" or "Could not connect"
- Verify your DB_PASSWORD is correct
- Check that your Supabase project is **Active** (not paused)
- Ensure port 5432 is not blocked by your firewall

### "SQLSTATE[28P01]: Invalid password"
- Your DB_PASSWORD is wrong. Reset it in Supabase Dashboard.

### "Class 'App\Models\...' not found"
- Run: `composer dump-autoload`

### "Permission denied" errors
- Run: `chmod -R 775 storage bootstrap/cache`

### Blank page or 500 error
- Check `storage/logs/laravel.log` for details
- Run: `php artisan config:clear && php artisan cache:clear`

### SSL connection error
- The app uses `sslmode=prefer` which should work. If issues persist, 
  change to `sslmode=require` in `config/database.php`

---

## 🌐 Supabase API (Optional)

If you want to use Supabase client libraries directly:
- **Project URL:** `https://mslydvabhamtjltuseno.supabase.co`
- **Anon Key:** Available in `.env.example.supabase`
- **Publishable Key:** `sb_publishable_bOQodFL-Gh9NKO7-vqLTIg_hipYVZfJ`

---

## 📝 Notes

1. **No migrations needed** — All tables are already created in Supabase
2. **No seeding needed** — All reference data is already seeded
3. **Session/Cache** — Uses file-based storage (works out of the box)
4. **File uploads** — Stored in `storage/app/` (linked via `php artisan storage:link`)
5. **PDF generation** — Uses DomPDF (already included in composer.json)

---

## 🔗 Quick Links

- **GitHub Repo:** https://github.com/UnicoShadow/lav-sms
- **Supabase Dashboard:** https://supabase.com/dashboard
- **Supabase Project:** UnicoShadow's Project (mslydvabhamtjltuseno)
- **Supabase Region:** ap-southeast-1 (Singapore)
