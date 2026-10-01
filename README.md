# 🛒 QuickBite- Online Food Ordering Web Application

A full-stack **Online Food Ordering System Built strictly following standard Enterprise Java MVC architecture without Spring, Hibernate, or React.

---

## ⚡ Tech Stack & Architecture

- **Backend**: Java Servlets (Jakarta Servlet 6.0, Tomcat 10+), JSP, JDBC with `PreparedStatement`, MySQL 8.0+
- **Security**: SHA-256 password hashing matching MySQL's native `SHA2()`, `AuthFilter` for customer routes, `AdminFilter` for admin portal, SQL injection protection, and XSS sanitization
- **Build System**: Maven (Packaging: `war`), with automated `build.bat` script
- **Frontend**: JSP + HTML5 + CSS3 + Vanilla JavaScript (ES6+)
- **UI & Animations**: 
  - **Bootstrap 5** (Layout & Modals via CDN)
  - **AOS** (Animate On Scroll for section reveals via CDN)
  - **GSAP 3** (Slide-in Cart Drawer, Hero Stagger, and Fly-To-Cart particle animations via CDN)
- **Design Tokens**: Blinkit Yellow (`#F8CB46`), Emerald Green (`#0C831F`), Pill steppers, rounded cards (`16px`), and sticky header

---

## 🏗️ MVC Architecture Breakdown

```
src/main/java/com/food/
├── model/           # POJO Domain Models (User, Category, FoodItem, Cart, CartItem, Address, Order, OrderItem)
├── dao/             # Data Access Objects using PreparedStatement (UserDAO, CategoryDAO, FoodItemDAO, AddressDAO, OrderDAO)
├── servlet/         # Jakarta HTTP Controllers (HomeServlet, AuthServlet, CartServlet, SearchServlet, CheckoutServlet, OrderServlet, AdminServlet, AdminFoodServlet)
├── filter/          # Security & Encoding Filters (AuthFilter, AdminFilter, EncodingFilter)
└── util/            # Helpers (DBConnection, PasswordUtil, JsonResponse)
```

---

## 📦 Features Overview

1. **Authentication & Roles**:
   - Customer & Admin registration, login, and secure session management.
   - SHA-256 password hashing.
   - Protected routes redirecting back to the original page after login.

2. **Blinkit Home Experience**:
   - Sticky header with pulsating **10 MINS** delivery tag.
   - Interactive Delivery Location modal mockup ("Indiranagar, Bengaluru").
   - Live Search bar with debounced AJAX suggestions dropdown and highlight matches.
   - Category chips with images and fast filtering.
   - Horizontal scrollable carousels per category with previous/next scroll controls.

3. **Iconic Blinkit Product Cards & Stepper**:
   - Food card with veg/non-veg indicator dot, 10-minute ETA badge, MRP strikethrough, and discount percentage pill.
   - **Blinkit Button Stepper**: Green bordered `ADD +` button smoothly morphs into solid green `[- qty +]` stepper upon interaction.

4. **Slide-in Cart Drawer (No Page Reloads)**:
   - Right-side slide-in drawer powered by GSAP.
   - Fly-to-cart animation where the item image flies into the cart badge.
   - Free delivery tracker: *"Add items worth ₹XX more for FREE delivery"* (Threshold: ₹199).
   - Live item rows with inline steppers, item totals, delivery partner fee, and handling fee.
   - Floating "View Cart" sticky bottom bar for mobile screens.

5. **Checkout & Payments**:
   - Address book: Select saved addresses or add a new delivery address with one click.
   - Payment choices: **Cash on Delivery (COD)** or **Instant UPI Mock** with QR code and UPI ID verification.
   - Transactional order creation (`conn.setAutoCommit(false)` with atomic rollback).

6. **Order Confirmation & Live Tracking Timeline**:
   - Animated celebration checkmark banner.
   - 4-step visual progress tracker: **Placed ➔ Preparing ➔ Out for Delivery ➔ Delivered**.
   - Itemized bill breakdown and delivery address recap.

7. **Order History**:
   - Track all past and current deliveries with live progress bar and status tags.

8. **Admin Operations Portal** (`/admin/dashboard`):
   - **Dashboard**: Live analytics on Total Revenue, Total Orders, Active Customers, and Menu Items.
   - **Food Catalog Manager** (`/admin/items`): Search and filter by category, add new items with live image preview, edit prices/units/diet, delete items, and toggle instant item availability via AJAX.
   - **Category Manager** (`/admin/categories`): Add, edit display order, update image URLs, and manage categories.
   - **Live Kitchen Dispatch** (`/admin/orders`): View customer orders, delivery addresses, and change status dropdown (**PLACED**, **PREPARING**, **OUT_FOR_DELIVERY**, **DELIVERED**, **CANCELLED**) in real-time.

---

## 🔑 Default Login Credentials

| Role | Email | Password |
|---|---|---|
| **Admin** | `admin@blinkit.com` | `Admin@123` |
| **Customer** | `user@blinkit.com` | `User@123` |

> *Tip: The login page includes 1-click **Quick Demo Login** buttons to automatically fill credentials.*

---

## 🚀 Setup & Deployment Guide

### Step 1: Database Setup (MySQL)

1. Open your MySQL client (MySQL Workbench, phpMyAdmin, or MySQL CLI).
2. Execute the schema script:
   ```sql
   source database/schema.sql;
   ```
3. Execute the seed script (loads categories, admin, customer, addresses, and 24 food items with Unsplash images):
   ```sql
   source database/seed.sql;
   ```
4. Verify database connection credentials in `src/main/resources/db.properties`:
   ```properties
   db.url=jdbc:mysql://localhost:3306/food_ordering_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&characterEncoding=UTF-8
   db.username=root
   db.password=your_mysql_password
   ```

---

### Step 2: Build the WAR Package

You can build the project using either **Maven** or the provided **`build.bat`** script:

#### Option A: Using Maven
```bash
mvn clean package
```
This generates `target/food-ordering-system.war`.

#### Option B: Using the Included Windows Build Script
```cmd
build.bat
```

---

### Step 3: Deploy to Apache Tomcat 10+

1. Download and extract **Apache Tomcat 10.1+** (compatible with Jakarta EE 9/10).
2. Copy `target/food-ordering-system.war` to Tomcat's `webapps/` directory:
   ```cmd
   copy target\food-ordering-system.war "<TOMCAT_HOME>\webapps\"
   ```
3. Start Tomcat:
   ```cmd
   <TOMCAT_HOME>\bin\startup.bat
   ```
4. Open your browser and navigate to:
   ```
   http://localhost:8080/food-ordering-system/
   ```

*(To run as root `http://localhost:8080/`, rename the war file to `ROOT.war` before copying to `webapps/`)*.

---

## 🧪 Testing Verification Checklist

- [x] **Home Page**: Category chips, trending carousels, and food cards render cleanly with images.
- [x] **Blinkit Stepper**: Clicking `ADD +` turns the button into `[- 1 +]`, updates header cart count, and plays fly-to-cart animation.
- [x] **Cart Drawer**: Opening the cart shows live items, free delivery countdown, and real-time total calculations without page reloads.
- [x] **Live Search**: Typing `"pizza"` or `"burger"` in the search bar displays instant suggestions with photo, category, and price.
- [x] **Checkout**: Logging in, choosing saved address or entering a new one, selecting COD or UPI, and placing the order.
- [x] **Order Confirmation**: Displays green checkmark, estimated delivery time, and 4-step tracking timeline.
- [x] **Order History**: Accessible via User Menu ➔ *My Orders & Tracking*.
- [x] **Admin Portal**: Accessible via `admin@blinkit.com` ➔ View revenue analytics, toggle item availability, and dispatch orders.
