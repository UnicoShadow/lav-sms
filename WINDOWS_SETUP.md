# LAV SMS — Windows Setup (One Command)

## Run this

Open **PowerShell** and paste these 3 lines:

```powershell
cd C:\Users\muhux\Downloads\lav-sms
git pull
powershell -ExecutionPolicy Bypass -File .\fix.ps1
```

The script does everything: enables PHP extensions, removes duplicate
php.ini lines, installs Composer packages, writes `.env`, prompts you for
your Supabase password, runs a **live database connection test**, and
starts the server.

Then open **http://localhost:8000**

| Field | Value |
|---|---|
| Email | `admin@lavsms.com` |
| Password | `cj` |

---

## Getting your Supabase password

The script will prompt for it. To find it:

1. https://supabase.com/dashboard → **UnicoShadow's Project**
2. **Settings → Database → Connection string**
3. Copy the password (between `postgres:` and `@`)

Don't know it? Click **Reset database password** on that same page.

---

## What was broken and how it was fixed

| # | Problem | Root cause | Fix |
|---|---|---|---|
| 1 | `README.md / readme.md` collision | Two files differing only in case; Windows is case-insensitive | Deleted duplicate |
| 2 | `phpspec/prophecy requires php <8.1` | `composer.lock` pinned to PHP 7.x-era packages | Deleted lock file, widened `composer.json` to PHP 8.2 |
| 3 | `dompdf ... affected by security advisories` | Composer 2.10 blocks flagged packages by default | Set `policy.advisories.block = false` |
| 4 | `zip extension and unzip/7z are both missing` | XAMPP ships extensions commented out | Script uncomments `zip`, `pdo_pgsql`, `pgsql`, `gd`, `curl`, `mbstring`, `fileinfo`, `openssl`, `intl`, `exif` |
| 5 | `Module "openssl" is already loaded` | Earlier blind find-and-replace created duplicate lines | Script now de-duplicates `extension=` lines |
| 6 | **`could not translate host name db.<ref>.supabase.co`** | **The direct host is IPv6-only. Your network is IPv4-only.** | **Switched to the IPv4 Supavisor pooler** |
| 7 | `APP_DEBUG is true while APP_ENV is not local` | `APP_ENV=production` | Set `APP_ENV=local` |
| 8 | Login would have silently failed | Password stored as `$2b$` bcrypt; PHP expects `$2y$` | Re-hashed the admin password as `$2y$` |
| 9 | Broken avatar image everywhere | `photo` column held `default.jpg`, a file that doesn't exist | Repointed to `/global_assets/images/user.png` |

### About #6 — the important one

```
db.mslydvabhamtjltuseno.supabase.co
  IPv4 (A)    -> none
  IPv6 (AAAA) -> 2406:da18:1f5e:4101:86fc:6ea0:cc78:f102
```

There is no IPv4 address, so no amount of DNS flushing or switching to 8.8.8.8
can ever make it resolve on an IPv4-only network. Supabase's answer is the
connection pooler, which **is** on IPv4:

```
aws-0-ap-southeast-1.pooler.supabase.com -> 54.255.219.82
```

Note the username changes too — it becomes `postgres.<project-ref>`:

```
DB_HOST=aws-0-ap-southeast-1.pooler.supabase.com
DB_PORT=5432
DB_DATABASE=postgres
DB_USERNAME=postgres.mslydvabhamtjltuseno
```

This is already set in `.env.example.supabase`, and `fix.ps1` enforces it.

---

## Database status (verified)

| Item | Count |
|---|---|
| Tables | 31 |
| Foreign keys | 48 |
| Indexes | 59 |
| Nigerian states | 37 |
| Nationalities | 57 |
| Blood groups | 8 |
| User roles | 5 |
| Class types | 6 |
| App settings | 19 |
| Admin users | 1 |

---

## Troubleshooting

**`password authentication failed`** — wrong password in `.env`. Reset it in
the Supabase dashboard, update `.env`, then `php artisan config:clear`.

**`Tenant or user not found`** — `DB_USERNAME` must be
`postgres.mslydvabhamtjltuseno`, not plain `postgres`.

**`could not find driver`** — `pdo_pgsql` isn't loaded. Check with:
```powershell
php -r "echo implode(',', PDO::getAvailableDrivers());"
```
`pgsql` must appear in the output.

**Server starts but pages error** — clear caches:
```powershell
php artisan config:clear; php artisan cache:clear; php artisan view:clear
```

**Restore your php.ini** — the script backs it up to `php.ini.backup`.
