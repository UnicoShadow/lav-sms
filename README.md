# LAV SMS - Laravel School Management System

A comprehensive School Management System built with **Laravel 8**, now configured with **Supabase (PostgreSQL)** as the database backend.

## 🚀 Features

- **User Roles**: Super Admin, Admin, Teacher, Parent, Accountant
- **Student Management**: Registration, profiles, admission numbers, dormitory assignment
- **Class Management**: Classes, sections, subjects, class types
- **Exam Management**: Exams, marks, grades, exam records, result sheets
- **Timetable**: Time table records, time slots, periods
- **Finance**: Payments, payment records, receipts
- **Library**: Books, book requests
- **Promotions**: Student promotion between sessions
- **PDF Generation**: Result sheets and reports via DomPDF

## 🛠️ Tech Stack

| Component | Technology |
|-----------|-----------|
| Backend | Laravel 8 (PHP 7.2+ / 8.0) |
| Database | Supabase PostgreSQL 17 |
| Frontend | Blade Templates, jQuery, Bootstrap |
| PDF | barryvdh/laravel-dompdf |
| Auth | Laravel UI |

## 📦 Installation

### Prerequisites
- PHP >= 7.2 (or 8.0)
- Composer
- A Supabase project (already configured)

### Setup Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/UnicoShadow/lav-sms.git
   cd lav-sms
   ```

2. **Install dependencies**
   ```bash
   composer install
   ```

3. **Configure environment**
   ```bash
   cp .env.example.supabase .env
   ```

   Edit `.env` and set:
   - `APP_KEY`: Run `php artisan key:generate`
   - `DB_PASSWORD`: Your Supabase database password (found in Supabase Dashboard → Settings → Database)

4. **Generate application key**
   ```bash
   php artisan key:generate
   ```

5. **Run migrations** (tables already exist in Supabase, but if needed)
   ```bash
   php artisan migrate
   ```

6. **Seed the database** (if starting fresh)
   ```bash
   php artisan db:seed
   ```

7. **Create storage link**
   ```bash
   php artisan storage:link
   ```

8. **Start the server**
   ```bash
   php artisan serve
   ```

## 🔐 Default Login Credentials

| Role | Email | Password |
|------|-------|----------|
| Super Admin | admin@lavsms.com | cj |

> ⚠️ **Important**: Change the default password immediately after first login!

## 🗄️ Supabase Configuration

- **Project URL**: https://mslydvabhamtjltuseno.supabase.co
- **Database Host**: db.mslydvabhamtjltuseno.supabase.co
- **Database Port**: 5432
- **Database Name**: postgres
- **Database User**: postgres

The database schema has been pre-configured with all 30 tables including:
- Users & Authentication
- Classes, Sections, Subjects
- Student & Staff Records
- Exams, Marks, Grades
- Payments & Receipts
- Books & Library
- Timetable
- Promotions

## 📁 Project Structure

```
lav-sms/
├── app/
│   ├── Http/Controllers/    # Application controllers
│   ├── Models/              # Eloquent models
│   ├── Helpers/             # Helper classes (Qs, Mk, Pay)
│   └── Repositories/        # Repository pattern
├── database/
│   ├── migrations/          # Database migrations
│   └── seeders/             # Database seeders
├── resources/views/         # Blade templates
├── public/                  # Public assets
├── routes/                  # Route definitions
└── config/                  # Configuration files
```

## 📝 Notes

- The `.env` file is gitignored for security. Use `.env.example.supabase` as your template.
- Supabase database password must be obtained from your Supabase dashboard.
- The application uses file-based sessions and cache by default.
- For production, consider using Redis for cache/sessions.

## 📄 License

This project is open-sourced software licensed under the [MIT license](LICENSE).

---

**Repository**: https://github.com/UnicoShadow/lav-sms  
**Supabase Project**: UnicoShadow's Project (mslydvabhamtjltuseno)
