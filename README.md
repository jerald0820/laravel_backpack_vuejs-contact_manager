# 📇 Laravel Backpack + Vue 3 Contact Manager

A modern contact management application built with **Laravel 10**, **Backpack for Laravel**, **Vue 3**, **Vite**, and **Tailwind CSS**.  
This project demonstrates a clean modular architecture using `nwidart/laravel-modules`, RESTful API for contacts, image uploads, and a sleek Vue-based interface.

---

## 🚀 Features

- Modular architecture (`nwidart/laravel-modules`)
- RESTful API for contact management
- Backpack admin dashboard
- Image upload & preview for contacts
- Vue 3 frontend with Vite
- Tailwind CSS design system
- Fully responsive UI

---

## 🧩 Tech Stack

| Tool / Library | Version | Purpose |
|----------------|----------|----------|
| **Laravel** | 10.x | Backend framework |
| **PHP** | ≥ 8.1 | Required for Laravel 10 |
| **Composer** | ≥ 2.5 | PHP dependency manager |
| **Node.js** | ≥ 18 | For Vite & Tailwind |
| **npm** | ≥ 9 | JS package manager |
| **Vite** | 5.x | Frontend build tool |
| **Vue** | 3.5.x | Frontend framework |
| **TailwindCSS** | 3.x | Styling framework |
| **Backpack for Laravel** | 6.x | Admin panel |
| **nwidart/laravel-modules** | 9.x | Modular development |

---

## ⚙️ Installation & Setup

### 1️⃣ Clone the Repository
```bash
git clone https://github.com/jerald0820/laravel_backpack_vuejs-contact_manager.git
cd laravel_backpack_vuejs-contact_manager
```

### 2️⃣ Install PHP Dependencies
```bash
composer install
```

3️⃣ Install Node Dependencies
```bash
npm install
```

4️⃣ Configure Environment

Copy .env.example to .env:
```bash
cp .env.example .env
```

Then open .env and update the following:
```ini
APP_NAME="Contact Manager"
APP_URL=http://127.0.0.1:8000

DB_DATABASE=contact_manager
DB_USERNAME=root
DB_PASSWORD=

FILESYSTEM_DISK=public
```

5️⃣ Generate App Key & Run Migrations
```bash
php artisan key:generate
php artisan migrate
```

6️⃣ Create Storage Link
```bash
php artisan storage:link
```

7️⃣ (Optional) Install Backpack Admin

If Backpack is not yet installed:
```bash
composer require backpack/crud
php artisan backpack:install
```

8️⃣ Run the Application

Run both Laravel and Vite servers in separate terminals:

Terminal 1:
```bash
php artisan serve
```

Terminal 2:
```bash
npm run dev
```

---

🌐 URLs
Section	URL
| View | URL |
|-------------|-------------|
| **Frontend (Contacts)** | http://127.0.0.1:8000/contacts |
| **Admin Dashboard	** | http://127.0.0.1:8000/admin |
	
---

🔐 Default Admin Credentials

| Field | Value |
|-------------|-------------|
| **Email** | admin@admin.com |
| **Password** | admin123 |

---