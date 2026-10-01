// ========================================================
// QuickBite Online Food Ordering System - Standalone Dev Server
// Pure Node.js (Zero external npm dependencies)
// Port: 8080 (http://localhost:8080)
// ========================================================

const http = require('http');
const fs = require('fs');
const path = require('path');
const url = require('url');
const querystring = require('querystring');

const PORT = process.env.PORT || 8080;
const WEBAPP_DIR = fs.existsSync(path.join(__dirname, 'public')) 
    ? path.join(__dirname, 'public') 
    : path.join(__dirname, 'src', 'main', 'webapp');

// --------------------------------------------------------
// IN-MEMORY FAKE DATABASE (Hardcoded Seed Data)
// --------------------------------------------------------
const DB = {
    categories: [
        { id: 1, name: 'Pizza', slug: 'pizza', description: 'Hot, crispy, cheesy pizzas loaded with fresh toppings', imageUrl: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=500&auto=format&fit=crop&q=80', displayOrder: 1, active: true },
        { id: 2, name: 'Burgers & Wraps', slug: 'burgers-wraps', description: 'Juicy grilled patties, crispy crunches and soft toasted buns', imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500&auto=format&fit=crop&q=80', displayOrder: 2, active: true },
        { id: 3, name: 'Biryani & Bowls', slug: 'biryani-bowls', description: 'Aromatic royal biryanis slow-cooked with exotic spices', imageUrl: 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=500&auto=format&fit=crop&q=80', displayOrder: 3, active: true },
        { id: 4, name: 'Quick Snacks & Fries', slug: 'snacks-fries', description: 'Golden fries, nuggets, crunchy bites for evening cravings', imageUrl: 'https://images.unsplash.com/photo-1576107232684-1279f3908594?w=500&auto=format&fit=crop&q=80', displayOrder: 4, active: true },
        { id: 5, name: 'Desserts & Sweet Bites', slug: 'desserts', description: 'Warm lava cakes, artisanal ice creams and traditional sweets', imageUrl: 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=500&auto=format&fit=crop&q=80', displayOrder: 5, active: true },
        { id: 6, name: 'Beverages & Shakes', slug: 'beverages', description: 'Thick fruit shakes, chilled cold coffee and fizzy refreshers', imageUrl: 'https://images.unsplash.com/photo-1517256064527-09c73fc73e38?w=500&auto=format&fit=crop&q=80', displayOrder: 6, active: true },
        { id: 7, name: 'Asian & Noodles', slug: 'asian-noodles', description: 'Wok-tossed Hakka noodles, fried rice and crispy spring rolls', imageUrl: 'https://images.unsplash.com/photo-1585032226651-759b368d7246?w=500&auto=format&fit=crop&q=80', displayOrder: 7, active: true }
    ],

    users: [
        { id: 1, name: 'QuickBite Super Admin', email: 'admin@quickbite.com', password: 'Admin@123', phone: '+91 9876543210', role: 'ADMIN' },
        { id: 2, name: 'Rahul Sharma', email: 'user@quickbite.com', password: 'User@123', phone: '+91 9123456780', role: 'CUSTOMER' },
        { id: 3, name: 'Priya Patel', email: 'priya@gmail.com', password: 'User@123', phone: '+91 9898989898', role: 'CUSTOMER' }
    ],

    addresses: [
        { id: 1, userId: 2, addressType: 'Home', addressLine1: 'Flat 402, Green Glen Heights', addressLine2: 'Outer Ring Road, Bellandur', landmark: 'Near EcoSpace Tech Park', city: 'Bengaluru', state: 'Karnataka', pincode: '560103', isDefault: true },
        { id: 2, userId: 2, addressType: 'Work', addressLine1: 'Tower B, 7th Floor, RMZ Infinity', addressLine2: 'Old Madras Road', landmark: 'Opposite Gopalan Mall', city: 'Bengaluru', state: 'Karnataka', pincode: '560016', isDefault: false }
    ],

    foodItems: [
        // Pizza
        { id: 1, categoryId: 1, categoryName: 'Pizza', name: 'Margherita Cheese Pizza', description: 'Authentic Italian tomato herb sauce topped with melted 100% Mozzarella cheese on a crisp crust.', price: 249, discountPrice: 199, unit: 'Regular (7 inch)', imageUrl: 'https://images.unsplash.com/photo-1604382354936-07c5d9983bd3?w=500&auto=format&fit=crop&q=80', isVeg: true, isPopular: true, isAvailable: true, rating: 4.8, deliveryTimeMins: 10 },
        { id: 2, categoryId: 1, categoryName: 'Pizza', name: 'Farmhouse Supreme Pizza', description: 'Crunchy bell peppers, red paprika, sliced black olives, sweet corn kernels and roasted red onions.', price: 399, discountPrice: 329, unit: 'Medium (10 inch)', imageUrl: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=500&auto=format&fit=crop&q=80', isVeg: true, isPopular: true, isAvailable: true, rating: 4.7, deliveryTimeMins: 12 },
        { id: 3, categoryId: 1, categoryName: 'Pizza', name: 'Smoky BBQ Chicken Pizza', description: 'Tender grilled chicken chunks infused with smoky Texas BBQ sauce, jalapeños and mozzarella.', price: 449, discountPrice: 379, unit: 'Medium (10 inch)', imageUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=500&auto=format&fit=crop&q=80', isVeg: false, isPopular: true, isAvailable: true, rating: 4.9, deliveryTimeMins: 14 },
        { id: 4, categoryId: 1, categoryName: 'Pizza', name: 'Paneer Tikka Stuffed Crust', description: 'Marinated charcoal-spiced cottage cheese cubes, fresh capsicum, mint drizzle, cheese-filled crust.', price: 429, discountPrice: 359, unit: 'Medium (10 inch)', imageUrl: 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=500&auto=format&fit=crop&q=80', isVeg: true, isPopular: false, isAvailable: true, rating: 4.6, deliveryTimeMins: 12 },
        
        // Burgers & Wraps
        { id: 5, categoryId: 2, categoryName: 'Burgers & Wraps', name: 'Crispy Veggie Crunch Burger', description: 'Golden spiced potato & pea patty, signature garlic aioli, crunchy iceberg lettuce in a toasted sesame bun.', price: 129, discountPrice: 89, unit: '1 pc (180g)', imageUrl: 'https://images.unsplash.com/photo-1550547660-d9450f859349?w=500&auto=format&fit=crop&q=80', isVeg: true, isPopular: true, isAvailable: true, rating: 4.6, deliveryTimeMins: 10 },
        { id: 6, categoryId: 2, categoryName: 'Burgers & Wraps', name: 'Grilled Chicken Maharaja Burger', description: 'Double juicy grilled chicken patties with melted cheese slice, tangy pickle relish and habanero sauce.', price: 239, discountPrice: 189, unit: '1 pc (240g)', imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500&auto=format&fit=crop&q=80', isVeg: false, isPopular: true, isAvailable: true, rating: 4.8, deliveryTimeMins: 12 },
        { id: 7, categoryId: 2, categoryName: 'Burgers & Wraps', name: 'Paneer Kathi Roll', description: 'Pan-seared spiced paneer cubes tossed with crunchy onions and mint-coriander dip rolled in flaky paratha.', price: 169, discountPrice: 139, unit: '1 roll (220g)', imageUrl: 'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?w=500&auto=format&fit=crop&q=80', isVeg: true, isPopular: false, isAvailable: true, rating: 4.5, deliveryTimeMins: 10 },
        { id: 8, categoryId: 2, categoryName: 'Burgers & Wraps', name: 'Double Egg & Chicken Wrap', description: 'Smoked succulent chicken strips enveloped with fluffy double egg omelette, peri-peri mayonnaise.', price: 209, discountPrice: 169, unit: '1 roll (260g)', imageUrl: 'https://images.unsplash.com/photo-1528735602780-2552fd46c7af?w=500&auto=format&fit=crop&q=80', isVeg: false, isPopular: true, isAvailable: true, rating: 4.7, deliveryTimeMins: 12 },

        // Biryani & Bowls
        { id: 9, categoryId: 3, categoryName: 'Biryani & Bowls', name: 'Hyderabadi Dum Chicken Biryani', description: 'Slow-cooked aromatic basmati rice with succulent bone-in chicken marinated in secret spices. Served with raita.', price: 349, discountPrice: 299, unit: 'Serves 1-2 (550g)', imageUrl: 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=500&auto=format&fit=crop&q=80', isVeg: false, isPopular: true, isAvailable: true, rating: 4.9, deliveryTimeMins: 15 },
        { id: 10, categoryId: 3, categoryName: 'Biryani & Bowls', name: 'Royal Lucknowi Veg Dum Biryani', description: 'Fragrant long-grain basmati layered with farm-fresh veggies, saffron milk, fried cashews and caramelised onions.', price: 279, discountPrice: 229, unit: 'Serves 1-2 (500g)', imageUrl: 'https://images.unsplash.com/photo-1645177628172-a94c1f96e6db?w=500&auto=format&fit=crop&q=80', isVeg: true, isPopular: true, isAvailable: true, rating: 4.7, deliveryTimeMins: 12 },
        { id: 11, categoryId: 3, categoryName: 'Biryani & Bowls', name: 'Tandoori Paneer Makhani Bowl', description: 'Smoky char-grilled paneer cubes simmered in creamy makhani gravy served atop steaming cumin-spiced basmati.', price: 269, discountPrice: 219, unit: 'Serves 1 (420g)', imageUrl: 'https://images.unsplash.com/photo-1589302168068-964664d93dc0?w=500&auto=format&fit=crop&q=80', isVeg: true, isPopular: false, isAvailable: true, rating: 4.6, deliveryTimeMins: 10 },
        { id: 12, categoryId: 3, categoryName: 'Biryani & Bowls', name: 'Butter Chicken Rice Bowl', description: 'Classic tender tandoori chicken cooked in rich silky tomato-butter gravy paired with fragrant steamed rice.', price: 319, discountPrice: 269, unit: 'Serves 1 (450g)', imageUrl: 'https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?w=500&auto=format&fit=crop&q=80', isVeg: false, isPopular: true, isAvailable: true, rating: 4.8, deliveryTimeMins: 12 },

        // Quick Snacks & Fries
        { id: 13, categoryId: 4, categoryName: 'Quick Snacks & Fries', name: 'Crispy Golden French Fries', description: 'Deep fried crisp golden potato batons lightly salted. Perfectly crunchy on the outside, fluffy inside.', price: 109, discountPrice: 79, unit: 'Regular (150g)', imageUrl: 'https://images.unsplash.com/photo-1576107232684-1279f3908594?w=500&auto=format&fit=crop&q=80', isVeg: true, isPopular: true, isAvailable: true, rating: 4.5, deliveryTimeMins: 8 },
        { id: 14, categoryId: 4, categoryName: 'Quick Snacks & Fries', name: 'Peri Peri Cheese Crusted Fries', description: 'Crispy fries dusted with hot African peri-peri seasoning and drenched with warm cheddar cheese drizzle.', price: 149, discountPrice: 119, unit: 'Large (200g)', imageUrl: 'https://images.unsplash.com/photo-1585109649139-366815a0d713?w=500&auto=format&fit=crop&q=80', isVeg: true, isPopular: true, isAvailable: true, rating: 4.8, deliveryTimeMins: 10 },
        { id: 15, categoryId: 4, categoryName: 'Quick Snacks & Fries', name: 'Crunchy Mozzarella Sticks (6 Pcs)', description: 'Breadcrumb crusted stringy mozzarella cheese fingers served with zesty Italian tomato marinara dip.', price: 189, discountPrice: 149, unit: '6 pcs (160g)', imageUrl: 'https://images.unsplash.com/photo-1531749668029-2db88e4276c7?w=500&auto=format&fit=crop&q=80', isVeg: true, isPopular: false, isAvailable: true, rating: 4.7, deliveryTimeMins: 10 },
        { id: 16, categoryId: 4, categoryName: 'Quick Snacks & Fries', name: 'Crispy Chicken Popcorn', description: 'Bite-sized pieces of boneless tender chicken enveloped in ultra-crunchy seasoned southern batter.', price: 219, discountPrice: 179, unit: '1 Tub (180g)', imageUrl: 'https://images.unsplash.com/photo-1562967914-608f82629710?w=500&auto=format&fit=crop&q=80', isVeg: false, isPopular: true, isAvailable: true, rating: 4.8, deliveryTimeMins: 10 },

        // Desserts
        { id: 17, categoryId: 5, categoryName: 'Desserts & Sweet Bites', name: 'Warm Chocolate Lava Cake', description: 'Rich chocolate sponge cake with an irresistible warm molten dark chocolate center that oozes out upon cut.', price: 119, discountPrice: 89, unit: '1 pc (90g)', imageUrl: 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=500&auto=format&fit=crop&q=80', isVeg: true, isPopular: true, isAvailable: true, rating: 4.9, deliveryTimeMins: 8 },
        { id: 18, categoryId: 5, categoryName: 'Desserts & Sweet Bites', name: 'Belgian Dark Chocolate Ice Cream', description: 'Creamy churned premium chocolate ice cream folded with bittersweet Belgian fudge chocolate chips.', price: 139, discountPrice: 109, unit: '1 Tub (125ml)', imageUrl: 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=500&auto=format&fit=crop&q=80', isVeg: true, isPopular: true, isAvailable: true, rating: 4.8, deliveryTimeMins: 8 },
        { id: 19, categoryId: 5, categoryName: 'Desserts & Sweet Bites', name: 'Hot Gulab Jamun with Rabdi (2 Pcs)', description: 'Khoya dumplings deep-fried and soaked in rose-cardamom syrup, served hot with chilled creamy rabdi.', price: 129, discountPrice: 99, unit: '2 pcs (140g)', imageUrl: 'https://images.unsplash.com/photo-1599785209707-a456fc1337bb?w=500&auto=format&fit=crop&q=80', isVeg: true, isPopular: false, isAvailable: true, rating: 4.7, deliveryTimeMins: 8 },
        { id: 20, categoryId: 5, categoryName: 'Desserts & Sweet Bites', name: 'Red Velvet Cream Cheese Jar Cake', description: 'Layers of crimson cocoa sponge interspersed with luscious Philadelphia cream cheese frosting in a jar.', price: 149, discountPrice: 119, unit: '1 Jar (150g)', imageUrl: 'https://images.unsplash.com/photo-1586985289688-ca3cf47d3e6e?w=500&auto=format&fit=crop&q=80', isVeg: true, isPopular: false, isAvailable: true, rating: 4.7, deliveryTimeMins: 8 },

        // Beverages
        { id: 21, categoryId: 6, categoryName: 'Beverages & Shakes', name: 'Classic Cold Coffee Frappe', description: 'Double shot of roasted Arabica espresso blended with chilled milk, sugar syrup and rich vanilla ice cream.', price: 129, discountPrice: 99, unit: '300 ml', imageUrl: 'https://images.unsplash.com/photo-1517256064527-09c73fc73e38?w=500&auto=format&fit=crop&q=80', isVeg: true, isPopular: true, isAvailable: true, rating: 4.8, deliveryTimeMins: 8 },
        { id: 22, categoryId: 6, categoryName: 'Beverages & Shakes', name: 'Ratnagiri Alphonso Mango Shake', description: 'Made with real seasonal Alphonso mango pulp, chilled whole milk and topped with diced fresh mango bits.', price: 159, discountPrice: 129, unit: '300 ml', imageUrl: 'https://images.unsplash.com/photo-1623065422902-30a2d299bbe4?w=500&auto=format&fit=crop&q=80', isVeg: true, isPopular: true, isAvailable: true, rating: 4.9, deliveryTimeMins: 8 },
        { id: 23, categoryId: 6, categoryName: 'Beverages & Shakes', name: 'Fresh Mint Mojito Cooler', description: 'Crushed garden-fresh spearmint leaves, tart lime wedges, sparkling club soda and a dash of cane sugar.', price: 109, discountPrice: 79, unit: '350 ml', imageUrl: 'https://images.unsplash.com/photo-1551024709-8f23befc6f87?w=500&auto=format&fit=crop&q=80', isVeg: true, isPopular: false, isAvailable: true, rating: 4.6, deliveryTimeMins: 8 },

        // Asian
        { id: 24, categoryId: 7, categoryName: 'Asian & Noodles', name: 'Veg Hakka Chowmein Noodles', description: 'Wok-tossed noodles with shredded purple cabbage, carrots, bell peppers, scallions and soy-chili sauce.', price: 199, discountPrice: 159, unit: 'Serves 1-2 (420g)', imageUrl: 'https://images.unsplash.com/photo-1585032226651-759b368d7246?w=500&auto=format&fit=crop&q=80', isVeg: true, isPopular: true, isAvailable: true, rating: 4.6, deliveryTimeMins: 12 }
    ],

    orders: [
        {
            id: 1,
            orderNumber: 'QKB-20261001-9841',
            userId: 2,
            customerName: 'Rahul Sharma',
            customerPhone: '+91 9123456780',
            deliveryAddressText: 'Flat 402, Green Glen Heights, Outer Ring Road, Bellandur, Bengaluru - 560103',
            subtotal: 288,
            deliveryFee: 0,
            handlingFee: 4,
            totalAmount: 292,
            paymentMethod: 'UPI',
            paymentStatus: 'PAID',
            orderStatus: 'OUT_FOR_DELIVERY',
            estimatedDeliveryMins: 10,
            formattedDate: '01 Oct 2026, 12:45 PM',
            items: [
                { id: 1, foodItemId: 1, itemName: 'Margherita Cheese Pizza', price: 199, quantity: 1, totalPrice: 199 },
                { id: 2, foodItemId: 5, itemName: 'Crispy Veggie Crunch Burger', price: 89, quantity: 1, totalPrice: 89 }
            ]
        }
    ]
};

// --------------------------------------------------------
// IN-MEMORY SESSION & CART STORE
// --------------------------------------------------------
const sessions = {}; // sessionId -> { user, cart: Map(foodId -> { item, quantity }) }

function getSession(req, res) {
    const cookies = req.headers.cookie || '';
    let sid = null;
    cookies.split(';').forEach(c => {
        const parts = c.trim().split('=');
        if (parts[0] === 'QUICKBITE_SID' || parts[0] === 'BLINKIT_SID') sid = parts[1];
    });

    if (!sid || !sessions[sid]) {
        sid = 'sid_' + Math.random().toString(36).substring(2) + Date.now();
        sessions[sid] = {
            user: DB.users.find(u => u.id === 2), // Default logged in as customer for instant preview!
            cart: new Map()
        };
        res.setHeader('Set-Cookie', `QUICKBITE_SID=${sid}; Path=/; HttpOnly`);
    }
    return sessions[sid];
}

function calculateCartTotals(cartMap) {
    const items = [];
    let totalQuantity = 0;
    let subtotal = 0;

    for (let [foodId, ci] of cartMap.entries()) {
        const price = ci.item.discountPrice || ci.item.price;
        const itemTotal = price * ci.quantity;
        totalQuantity += ci.quantity;
        subtotal += itemTotal;
        items.push({
            id: ci.item.id,
            name: ci.item.name,
            unit: ci.item.unit,
            imageUrl: ci.item.imageUrl,
            price: ci.item.price,
            discountPrice: ci.item.discountPrice,
            effectivePrice: price,
            isVeg: ci.item.isVeg,
            quantity: ci.quantity,
            itemTotal: itemTotal
        });
    }

    const freeDeliveryThreshold = 199;
    const isFreeDeliveryEligible = subtotal >= freeDeliveryThreshold && items.length > 0;
    const deliveryFee = (items.length === 0 || isFreeDeliveryEligible) ? 0 : 25;
    const handlingFee = items.length === 0 ? 0 : 4;
    const grandTotal = items.length === 0 ? 0 : (subtotal + deliveryFee + handlingFee);
    const amountNeededForFreeDelivery = Math.max(0, freeDeliveryThreshold - subtotal);

    return {
        items,
        totalQuantity,
        itemCount: items.length,
        subtotal,
        deliveryFee,
        handlingFee,
        grandTotal,
        freeDeliveryThreshold,
        isFreeDeliveryEligible,
        amountNeededForFreeDelivery,
        isEmpty: items.length === 0
    };
}

// --------------------------------------------------------
// HTML TEMPLATE RENDERER
// --------------------------------------------------------
function renderPage(content, title, session, searchQuery = '') {
    const user = session.user;
    return `<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${title || 'QuickBite - 10 Minute Grocery & Food Delivery'}</title>
    <link rel="icon" type="image/svg+xml" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'><rect width='100' height='100' rx='20' fill='%23E23744'/><text y='70' x='50' font-size='56' text-anchor='middle' font-family='sans-serif' font-weight='bold' fill='%23FFFFFF'>Q</text></svg>">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
    <link href="/css/blinkit-theme.css" rel="stylesheet">
</head>
<body>
    <!-- HEADER -->
    <header class="blinkit-header py-2">
        <div class="container-fluid px-lg-5">
            <div class="row align-items-center gy-2">
                <div class="col-auto d-flex align-items-center gap-3">
                    <a href="/home" class="brand-logo-wrap">
                        <div class="brand-title">Quick<span>Bite</span></div>
                    </a>
                    <div class="location-selector d-none d-md-block" data-bs-toggle="modal" data-bs-target="#locationModal">
                        <div class="location-heading">
                            <span class="delivery-badge"><span class="pulse-dot"></span> 10 MINS</span>
                            <span>Delivery to</span>
                        </div>
                        <div class="location-address" id="headerLocationDisplay">Indiranagar, Bengaluru, 560038</div>
                    </div>
                </div>

                <div class="col">
                    <div class="search-wrapper">
                        <form id="mainSearchForm" action="/search" method="GET" class="search-input-box">
                            <span class="search-icon-left">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
                            </span>
                            <input type="text" id="mainSearchInput" name="q" class="search-input" placeholder='Search "pizza", "burger", "biryani", "desserts"...' value="${searchQuery}" autocomplete="off">
                            <button type="button" id="searchClearBtn" class="search-clear-btn">✕</button>
                        </form>
                        <div id="searchSuggestionsDropdown" class="search-suggestions-dropdown"></div>
                    </div>
                </div>

                <div class="col-auto d-flex align-items-center gap-2">
                    ${user ? `
                        <div class="dropdown">
                            <button class="btn btn-nav-login dropdown-toggle d-flex align-items-center gap-2" type="button" data-bs-toggle="dropdown">
                                <span class="badge bg-light text-dark rounded-circle p-2 border">👤</span>
                                <span class="d-none d-lg-inline">${user.name}</span>
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0 rounded-3 mt-2">
                                <li class="px-3 py-2 border-bottom">
                                    <div class="fw-bold">${user.name}</div>
                                    <div class="small text-muted">${user.email} (${user.role})</div>
                                </li>
                                <li><a class="dropdown-item py-2" href="/orders">📦 My Orders & Tracking</a></li>
                                ${user.role === 'ADMIN' ? '<li><a class="dropdown-item py-2 text-danger fw-bold" href="/admin/dashboard">⚙️ Admin Dashboard</a></li>' : ''}
                                <li><hr class="dropdown-divider my-1"></li>
                                <li><a class="dropdown-item py-2 text-danger" href="/logout">🚪 Logout</a></li>
                            </ul>
                        </div>
                    ` : `
                        <a href="/login" class="btn btn-nav-login">Login</a>
                    `}

                    <button type="button" id="headerCartBtn" class="btn-blinkit-cart trigger-cart-drawer">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2"><circle cx="9" cy="21" r="1"></circle><circle cx="20" cy="21" r="1"></circle><path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"></path></svg>
                        <span class="d-none d-sm-inline">My Cart</span>
                    </button>
                </div>
            </div>
        </div>
    </header>

    <!-- CONTENT BODY -->
    ${content}

    <!-- CART DRAWER -->
    <div id="cartDrawerOverlay" class="cart-drawer-overlay"></div>
    <aside id="cartDrawer" class="cart-drawer">
        <div class="cart-drawer-header">
            <div class="cart-drawer-title"><span>My Cart</span></div>
            <button type="button" id="closeCartDrawerBtn" class="btn-close-drawer">✕</button>
        </div>
        <div id="cartDeliveryBanner" class="cart-delivery-strip" style="display: none;">
            <span>⚡</span>
            <div>Delivery in <strong>10 minutes</strong> to your doorstep</div>
        </div>
        <div id="cartDrawerItemsList" class="cart-drawer-body"></div>
        <div id="cartDrawerFooter" class="cart-drawer-footer" style="display: none;"></div>
    </aside>

    <div id="mobileCartFloatBar" class="mobile-cart-float-bar trigger-cart-drawer">
        <div class="mobile-float-left"><span>🛒</span><span class="cart-badge-count">0</span> items • <span class="cart-badge-total">₹0</span></div>
        <div class="mobile-float-right"><span>View Cart</span><span>→</span></div>
    </div>

    <!-- FOOTER -->
    <footer class="bg-white border-top mt-5 pt-5 pb-4">
        <div class="container-fluid px-lg-5">
            <div class="row g-4 mb-4">
                <div class="col-lg-4 col-md-6">
                    <div class="brand-title mb-2">Quick<span>Bite</span></div>
                    <p class="text-muted small">Hot &amp; fresh food delivery in 10 minutes. Powered by QuickBite in-memory MockDatabase.</p>
                    <div class="d-flex align-items-center gap-2">
                        <span class="badge bg-light text-dark p-2 border">⚡ 10 Min Delivery</span>
                        <span class="badge bg-light text-dark p-2 border">🛡️ Safe & Hygienic</span>
                        <span class="badge bg-light text-dark p-2 border">💳 Instant UPI / COD</span>
                    </div>
                </div>
                <div class="col-lg-2 col-md-3 col-6">
                    <h6 class="fw-bold mb-3">Categories</h6>
                    <ul class="list-unstyled small text-muted d-flex flex-column gap-2">
                        ${DB.categories.map(c => `<li><a href="/search?cat=${c.id}" class="text-decoration-none text-muted">${c.name}</a></li>`).join('')}
                    </ul>
                </div>
                <div class="col-lg-2 col-md-3 col-6">
                    <h6 class="fw-bold mb-3">Customer Support</h6>
                    <ul class="list-unstyled small text-muted d-flex flex-column gap-2">
                        <li><a href="/orders" class="text-decoration-none text-muted">My Orders</a></li>
                        <li><a href="/admin/dashboard" class="text-decoration-none text-danger fw-bold">Admin Portal</a></li>
                    </ul>
                </div>
                <div class="col-lg-4 col-md-6">
                    <div class="p-3 bg-light rounded-3 small text-muted border">
                        <div class="fw-bold text-dark mb-1">⚡ 10-Minute Promise</div>
                        Pre-seeded with 24 delicious dishes across 7 categories. No MySQL required.
                    </div>
                </div>
            </div>
            <hr class="my-4">
            <div class="d-flex justify-content-between small text-muted">
                <div>© 2026 QuickBite - 10-Minute Food Delivery (In-Memory Database Mode)</div>
                <div>Server active on <strong>http://localhost:8080</strong></div>
            </div>
        </div>
    </footer>

    <!-- Location Modal -->
    <div class="modal fade" id="locationModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content rounded-4 border-0 shadow">
                <div class="modal-header border-0 pb-0">
                    <h5 class="modal-title fw-bold">Select Delivery Location</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="list-group">
                        <button type="button" class="list-group-item list-group-item-action d-flex align-items-center gap-3 py-3 rounded-3 mb-2 border" onclick="selectLocation('Indiranagar, Bengaluru, 560038')">
                            <span class="fs-4">🏠</span>
                            <div><div class="fw-bold">Home - Indiranagar</div><div class="small text-muted">100ft Road, Near Metro Station, Bengaluru</div></div>
                        </button>
                        <button type="button" class="list-group-item list-group-item-action d-flex align-items-center gap-3 py-3 rounded-3 mb-2 border" onclick="selectLocation('EcoSpace Tech Park, Bellandur, 560103')">
                            <span class="fs-4">🏢</span>
                            <div><div class="fw-bold">Work - EcoSpace Tech Park</div><div class="small text-muted">Outer Ring Road, Bellandur, Bengaluru</div></div>
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.5/gsap.min.js"></script>
    <script src="/js/toast.js"></script>
    <script src="/js/cart.js"></script>
    <script src="/js/search.js"></script>
    <script src="/js/animations.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', () => {
            BlinkitCart.init('');
            BlinkitSearch.init('');
        });
        function selectLocation(loc) {
            const headerLoc = document.getElementById('headerLocationDisplay');
            if (headerLoc) headerLoc.textContent = loc;
            const heroLoc = document.getElementById('heroLocationDisplay');
            if (heroLoc) heroLoc.textContent = loc;
            const modalEl = document.getElementById('locationModal');
            const modal = bootstrap.Modal.getInstance(modalEl);
            if (modal) modal.hide();
            if (window.showToast) showToast('Location Updated', 'Delivering to: ' + loc, 'success');
        }
    </script>
</body>
</html>`;
}

// --------------------------------------------------------
// PAGE GENERATORS
// --------------------------------------------------------
function renderHomePage(session) {
    const popularItems = DB.foodItems.filter(f => f.isPopular);

    let html = `
    <!-- FULLSCREEN HERO SECTION WITH SCROLL-DRIVEN PARALLAX & MEGA SEARCH -->
    <section id="quickbiteHero" class="quickbite-fullscreen-hero">
        <!-- Ambient glowing spheres -->
        <div class="hero-ambient-glow glow-red"></div>
        <div class="hero-ambient-glow glow-amber"></div>

        <div class="container-fluid px-lg-5 hero-inner-container">
            <div class="row align-items-center min-vh-hero gy-4">
                
                <!-- Left Column: Typography, Mega Search, Cuisine Cravings & Badges -->
                <div class="col-lg-7 hero-text-col" id="heroTextSection">
                    <div class="hero-tag-wrap mb-2">
                        <span class="hero-pill-tag">⚡ India's Fastest 10-Minute Food Delivery</span>
                    </div>
                    
                    <h1 class="hero-main-title">
                        Craving Great Food? <br>
                        Delivered Hot in <span class="hero-gradient-text">10 Minutes.</span>
                    </h1>
                    
                    <p class="hero-description">
                        Wood-fired pizzas, juicy burgers, royal Hyderabadi dum biryani & artisanal desserts from hyper-local gourmet kitchens.
                    </p>

                    <!-- Zomato-inspired Interactive Mega Search Bar -->
                    <div class="hero-mega-search-wrapper my-3">
                        <form action="/search" method="GET" class="hero-search-box">
                            <div class="hero-search-location d-none d-md-flex" data-bs-toggle="modal" data-bs-target="#locationModal">
                                <span class="location-pin-icon">📍</span>
                                <span class="location-text text-truncate" id="heroLocationDisplay">Indiranagar, Bengaluru</span>
                                <span class="location-caret">▼</span>
                            </div>
                            <div class="hero-search-divider d-none d-md-block"></div>
                            <div class="hero-search-input-wrap">
                                <span class="hero-search-lens">🔍</span>
                                <input type="text" name="q" class="hero-search-input" placeholder='Search for "wood-fired pizza", "dum biryani"...' autocomplete="off">
                                <button type="submit" class="hero-search-submit-btn">
                                    <span>Search</span>
                                    <span class="arrow-icon">→</span>
                                </button>
                            </div>
                        </form>
                    </div>

                    <!-- Popular Quick Cuisine Cravings -->
                    <div class="hero-popular-cuisines">
                        <span class="cuisines-label">Popular Cravings:</span>
                        <div class="cuisines-pills-list">
                            <a href="/search?cat=1" class="cuisine-pill">🍕 Pizza</a>
                            <a href="/search?cat=2" class="cuisine-pill">🍔 Burgers</a>
                            <a href="/search?cat=3" class="cuisine-pill">🍲 Biryani</a>
                            <a href="/search?cat=4" class="cuisine-pill">🍟 Snacks</a>
                            <a href="/search?cat=5" class="cuisine-pill">🍰 Desserts</a>
                            <a href="/search?cat=6" class="cuisine-pill">🥤 Shakes</a>
                        </div>
                    </div>

                    <!-- Value / Guarantee Badges -->
                    <div class="hero-feature-badges mt-4">
                        <div class="feature-badge-item"><span>🚀</span> Free delivery above ₹199</div>
                        <div class="feature-badge-item"><span>🔥</span> Hot & Fresh Guarantee</div>
                        <div class="feature-badge-item"><span>🛡️</span> 100% Hygienic Packaging</div>
                    </div>
                </div>

                <!-- Right Column: 3D Visual Centerpiece & Satellite Parallax Food Elements -->
                <div class="col-lg-5 hero-visual-col" id="heroVisualSection">
                    <div class="hero-composition-wrap">
                        <!-- Layer 1: Ambient Food Backdrop Ring -->
                        <div class="hero-visual-backdrop"></div>

                        <!-- Layer 2: Main Artisan Centerpiece Dish with Parallax & Scale -->
                        <div class="hero-centerpiece-wrap" id="heroCenterpiece">
                            <img src="https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=700&auto=format&fit=crop&q=85" 
                                 alt="Gourmet Artisanal Pizza" class="hero-centerpiece-img">
                        </div>

                        <!-- Layer 3: Floating Satellite Cards with Asymmetric Parallax Drift -->
                        <!-- Satellite 1 (Top-Left): Dum Biryani -->
                        <div class="hero-floating-card card-top-left" id="floatingCard1">
                            <img src="https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=200&auto=format&fit=crop&q=80" alt="Hyderabadi Biryani" class="floating-dish-thumb">
                            <div class="floating-card-info">
                                <span class="floating-card-title">Dum Biryani</span>
                                <span class="floating-card-meta">⭐ 4.9 • 15 Mins</span>
                            </div>
                        </div>

                        <!-- Satellite 2 (Bottom-Right): Crunch Burger -->
                        <div class="hero-floating-card card-bottom-right" id="floatingCard2">
                            <img src="https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=200&auto=format&fit=crop&q=80" alt="Crunch Burger" class="floating-dish-thumb">
                            <div class="floating-card-info">
                                <span class="floating-card-title">Crunch Burger</span>
                                <span class="floating-card-meta">⚡ 10 Mins • ₹89</span>
                            </div>
                        </div>

                        <!-- Satellite 3 (Bottom-Left): 10 Mins Badge -->
                        <div class="hero-floating-badge badge-bottom-left" id="floatingBadge1">
                            <span class="badge-icon">⚡</span>
                            <div class="badge-text-wrap">
                                <strong>10 MINS</strong>
                                <small>Doorstep Delivery</small>
                            </div>
                        </div>

                        <!-- Satellite 4 (Top-Right): Promo Chip -->
                        <div class="hero-floating-badge badge-top-right" id="floatingBadge2">
                            <span class="badge-icon">🏷️</span>
                            <div class="badge-text-wrap">
                                <strong>50% OFF</strong>
                                <small>Up to ₹100 First Order</small>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>

        <!-- Scroll Down Prompt Indicator -->
        <a href="#menuSection" class="hero-scroll-indicator" id="heroScrollIndicator" aria-label="Scroll to menu">
            <div class="mouse-scroll-icon">
                <div class="mouse-scroll-wheel"></div>
            </div>
            <span class="scroll-indicator-text">Scroll to explore menu</span>
        </a>
    </section>

    <main id="menuSection" class="container-fluid px-lg-5 pt-3">

        <!-- CATEGORIES -->
        <section class="mb-4" data-aos="fade-up">
            <h2 class="fs-5 fw-bold mb-2">Explore Categories</h2>
            <div class="category-chips-wrapper">
                ${DB.categories.map(c => `
                    <a href="/search?cat=${c.id}" class="category-chip-card">
                        <img src="${c.imageUrl}" alt="${c.name}" class="category-chip-img">
                        <span class="category-chip-name">${c.name}</span>
                    </a>
                `).join('')}
            </div>
        </section>

        <!-- POPULAR CAROUSEL -->
        <section class="mb-5 carousel-container-wrap" data-aos="fade-up">
            <div class="d-flex align-items-center justify-content-between mb-3">
                <div>
                    <h2 class="fs-4 fw-bold mb-0">🔥 Trending Right Now</h2>
                    <span class="text-muted small">Top ordered dishes by foodies near you</span>
                </div>
                <div class="d-flex gap-2">
                    <button type="button" class="btn btn-sm btn-light border rounded-circle carousel-btn-left">◀</button>
                    <button type="button" class="btn btn-sm btn-light border rounded-circle carousel-btn-right">▶</button>
                </div>
            </div>
            <div class="product-carousel-row">
                ${popularItems.map(item => renderFoodCard(item)).join('')}
            </div>
        </section>

        <!-- CATEGORY SECTIONS -->
        ${DB.categories.map(cat => {
            const items = DB.foodItems.filter(f => f.categoryId === cat.id && f.isAvailable);
            if (items.length === 0) return '';
            return `
            <section class="mb-5 carousel-container-wrap" data-aos="fade-up">
                <div class="d-flex align-items-center justify-content-between mb-3">
                    <div>
                        <h2 class="fs-4 fw-bold mb-0">${cat.name}</h2>
                        <span class="text-muted small">${cat.description}</span>
                    </div>
                    <div class="d-flex align-items-center gap-2">
                        <a href="/search?cat=${cat.id}" class="text-danger fw-bold small text-decoration-none me-2">See All →</a>
                        <button type="button" class="btn btn-sm btn-light border rounded-circle carousel-btn-left">◀</button>
                        <button type="button" class="btn btn-sm btn-light border rounded-circle carousel-btn-right">▶</button>
                    </div>
                </div>
                <div class="product-carousel-row">
                    ${items.map(item => renderFoodCard(item)).join('')}
                </div>
            </section>
            `;
        }).join('')}
    </main>
    `;
    return renderPage(html, 'QuickBite - 10 Minute Food Delivery', session);
}

function renderFoodCard(item) {
    const currentPrice = item.discountPrice || item.price;
    const hasDiscount = item.discountPrice && item.discountPrice < item.price;
    const discountPct = hasDiscount ? Math.round((1 - item.discountPrice / item.price) * 100) : 0;

    return `
    <div class="food-card">
        <div class="food-card-img-wrap">
            <div class="diet-icon ${item.isVeg ? 'veg' : 'non-veg'}"></div>
            ${hasDiscount ? `<div class="discount-badge-corner">${discountPct}% OFF</div>` : ''}
            <img src="${item.imageUrl}" alt="${item.name}" class="food-card-img" onerror="this.src='https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=300'">
            <div class="delivery-badge-tag"><span>⚡</span> ${item.deliveryTimeMins} MINS</div>
        </div>
        <div>
            <div class="food-name" title="${item.name}">${item.name}</div>
            <div class="food-unit">${item.unit}</div>
        </div>
        <div class="food-card-bottom">
            <div class="food-prices">
                <div class="food-price-current">₹${currentPrice}</div>
                ${hasDiscount ? `<div class="food-price-mrp">₹${item.price}</div>` : ''}
            </div>
            <div class="stepper-container" data-food-id="${item.id}">
                <button type="button" class="btn-add-food" onclick="BlinkitCart.addItem(${item.id}, this)">
                    ADD <span>+</span>
                </button>
            </div>
        </div>
    </div>`;
}

function renderSearchPage(query, catId, session) {
    let items = DB.foodItems.filter(f => f.isAvailable);
    let title = 'All Food Items';

    if (catId) {
        const cat = DB.categories.find(c => c.id === parseInt(catId));
        if (cat) {
            items = items.filter(f => f.categoryId === cat.id);
            title = cat.name;
        }
    } else if (query) {
        const q = query.toLowerCase();
        items = items.filter(f => f.name.toLowerCase().includes(q) || f.description.toLowerCase().includes(q) || f.categoryName.toLowerCase().includes(q));
        title = `Results for "${query}"`;
    }

    const html = `
    <main class="container-fluid px-lg-5 my-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h1 class="fs-3 fw-bold mb-1">${title}</h1>
                <span class="text-muted small">${items.length} items available</span>
            </div>
        </div>

        <div class="category-chips-wrapper mb-4">
            <a href="/search" class="category-chip-card ${!catId && !query ? 'active' : ''}">
                <div class="category-chip-img d-flex align-items-center justify-content-center fs-4">🍽️</div>
                <span class="category-chip-name">All</span>
            </a>
            ${DB.categories.map(c => `
                <a href="/search?cat=${c.id}" class="category-chip-card ${catId == c.id ? 'active' : ''}">
                    <img src="${c.imageUrl}" alt="${c.name}" class="category-chip-img">
                    <span class="category-chip-name">${c.name}</span>
                </a>
            `).join('')}
        </div>

        <div class="row row-cols-2 row-cols-sm-3 row-cols-md-4 row-cols-lg-5 row-cols-xl-6 g-3">
            ${items.map(item => `
                <div class="col">
                    ${renderFoodCard(item)}
                </div>
            `).join('')}
        </div>
    </main>`;
    return renderPage(html, `Search Food - QuickBite`, session, query);
}

function renderCheckoutPage(session) {
    const cartTotals = calculateCartTotals(session.cart);
    const user = session.user;
    const addresses = DB.addresses.filter(a => a.userId === user.id);

    const html = `
    <main class="container my-4">
        <div class="row g-4">
            <div class="col-lg-7">
                <div class="d-flex align-items-center gap-2 mb-3">
                    <span class="delivery-badge fs-6"><span class="pulse-dot"></span> 10 MINS</span>
                    <h1 class="fs-4 fw-bold mb-0">Delivery &amp; Payment</h1>
                </div>

                <form action="/checkout" method="POST">
                    <div class="card border-0 shadow-sm rounded-4 p-4 bg-white mb-4">
                        <h2 class="fs-5 fw-bold mb-3">📍 Delivery Address</h2>
                        <div class="mb-3">
                            ${addresses.map(a => `
                                <label class="p-3 border rounded-3 d-flex align-items-start gap-3 w-100 mb-2 cursor-pointer ${a.isDefault ? 'border-danger bg-light' : ''}">
                                    <input type="radio" name="selectedAddressId" value="${a.id}" ${a.isDefault ? 'checked' : ''} class="mt-1">
                                    <div>
                                        <div class="fw-bold text-dark">${a.addressType} ${a.isDefault ? '<span class="badge bg-danger ms-2">Default</span>' : ''}</div>
                                        <div class="small text-muted">${a.addressLine1}, ${a.addressLine2 || ''} (${a.landmark || ''}), ${a.city} - ${a.pincode}</div>
                                    </div>
                                </label>
                            `).join('')}
                        </div>
                        <div class="mt-2">
                            <label class="form-label small text-muted">Delivery Instructions</label>
                            <input type="text" name="orderNotes" class="form-control rounded-3" placeholder="e.g. Ring bell twice or leave at door">
                        </div>
                    </div>

                    <div class="card border-0 shadow-sm rounded-4 p-4 bg-white mb-4">
                        <h2 class="fs-5 fw-bold mb-3">💳 Payment Mode</h2>
                        <div class="d-flex flex-column gap-3">
                            <label class="p-3 border rounded-3 d-flex align-items-center justify-content-between cursor-pointer">
                                <div class="d-flex align-items-center gap-3">
                                    <input type="radio" name="paymentMethod" value="UPI" checked>
                                    <div>
                                        <div class="fw-bold text-dark">UPI Instant Payment (Google Pay / PhonePe / Paytm)</div>
                                        <div class="small text-muted">Fast &amp; contactless 1-click verification</div>
                                    </div>
                                </div>
                                <span class="fs-4">⚡</span>
                            </label>
                            <label class="p-3 border rounded-3 d-flex align-items-center justify-content-between cursor-pointer">
                                <div class="d-flex align-items-center gap-3">
                                    <input type="radio" name="paymentMethod" value="COD">
                                    <div>
                                        <div class="fw-bold text-dark">Cash on Delivery (COD)</div>
                                        <div class="small text-muted">Pay cash or scan QR when food arrives</div>
                                    </div>
                                </div>
                                <span class="fs-4">💵</span>
                            </label>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-danger w-100 py-3 fw-bold rounded-4 fs-5" style="background-color: var(--theme-red); border-color: var(--theme-red);">
                        Place Order • ₹${cartTotals.grandTotal}
                    </button>
                </form>
            </div>

            <div class="col-lg-5">
                <div class="card border-0 shadow-sm rounded-4 p-4 bg-white sticky-top" style="top: 80px;">
                    <h2 class="fs-5 fw-bold mb-3">Order Summary (${cartTotals.totalQuantity} items)</h2>
                    <div class="overflow-auto pe-1 mb-3" style="max-height: 280px;">
                        ${cartTotals.items.map(ci => `
                            <div class="d-flex align-items-center gap-3 py-2 border-bottom">
                                <img src="${ci.imageUrl}" class="rounded-3" style="width: 48px; height: 48px; object-fit: cover;">
                                <div class="flex-grow-1">
                                    <div class="fw-bold small text-dark">${ci.name}</div>
                                    <div class="text-muted" style="font-size: 11px;">Qty: ${ci.quantity} × ₹${ci.effectivePrice}</div>
                                </div>
                                <div class="fw-bold small text-dark">₹${ci.itemTotal}</div>
                            </div>
                        `).join('')}
                    </div>
                    <div class="d-flex justify-content-between small text-muted mb-2"><span>Item Total</span><span>₹${cartTotals.subtotal}</span></div>
                    <div class="d-flex justify-content-between small text-muted mb-2"><span>Delivery Fee</span><span>${cartTotals.deliveryFee === 0 ? '<del class="text-muted me-1">₹25</del> <span class="text-danger fw-bold">FREE</span>' : '₹' + cartTotals.deliveryFee}</span></div>
                    <div class="d-flex justify-content-between small text-muted mb-2"><span>Handling Fee</span><span>₹${cartTotals.handlingFee}</span></div>
                    <hr class="my-2">
                    <div class="d-flex justify-content-between fs-5 fw-bold text-dark pt-1"><span>To Pay</span><span class="text-danger">₹${cartTotals.grandTotal}</span></div>
                </div>
            </div>
        </div>
    </main>`;
    return renderPage(html, 'Checkout - QuickBite', session);
}

function renderOrderConfirmationPage(orderNumber, session) {
    const order = DB.orders.find(o => o.orderNumber === orderNumber) || DB.orders[0];
    const html = `
    <main class="container my-5">
        <div class="row justify-content-center">
            <div class="col-lg-7 text-center">
                <div class="card border-0 shadow-sm rounded-4 p-5 bg-white">
                    <div class="d-inline-flex align-items-center justify-content-center rounded-circle bg-danger-subtle text-danger p-3 fs-1 mx-auto mb-3" style="width: 80px; height: 80px;">✓</div>
                    <h1 class="fs-2 fw-bold text-dark">Order Placed Successfully!</h1>
                    <p class="text-muted mb-3">Order <strong>#${order.orderNumber}</strong> is being prepared right now.</p>
                    <div class="d-inline-flex align-items-center gap-2 bg-light px-3 py-2 rounded-pill mx-auto mb-4 border">
                        <span class="pulse-dot"></span>
                        <span class="fw-bold text-dark small">Estimated Delivery: <strong>${order.estimatedDeliveryMins} Minutes</strong></span>
                    </div>

                    <div class="order-tracker-card text-start mt-2">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <span class="fw-bold fs-6">Live Order Tracking</span>
                            <span class="badge bg-danger px-3 py-2">${order.orderStatus}</span>
                        </div>
                        <div class="timeline-track">
                            <div class="timeline-progress-bar" style="width: 66%;"></div>
                            <div class="timeline-step completed"><div class="step-node">📝</div><div class="step-title">Placed</div></div>
                            <div class="timeline-step completed"><div class="step-node">🍳</div><div class="step-title">Preparing</div></div>
                            <div class="timeline-step active"><div class="step-node">🛵</div><div class="step-title">On The Way</div></div>
                            <div class="timeline-step"><div class="step-node">🏠</div><div class="step-title">Delivered</div></div>
                        </div>
                    </div>

                    <div class="bg-light rounded-4 p-4 text-start mb-4 border">
                        <div class="small fw-bold mb-2">Delivering to: ${order.deliveryAddressText}</div>
                        <div class="small text-muted mb-3">Payment: ${order.paymentMethod} • Status: <span class="badge bg-danger">${order.paymentStatus}</span></div>
                        <hr>
                        ${order.items.map(it => `
                            <div class="d-flex justify-content-between small py-1">
                                <span>${it.itemName} × ${it.quantity}</span>
                                <span class="fw-bold">₹${it.totalPrice}</span>
                            </div>
                        `).join('')}
                        <hr>
                        <div class="d-flex justify-content-between fw-bold text-dark">
                            <span>Total Paid</span>
                            <span class="text-danger fs-5">₹${order.totalAmount}</span>
                        </div>
                    </div>

                    <div class="d-flex gap-2 justify-content-center">
                        <a href="/orders" class="btn btn-outline-danger rounded-pill px-4 fw-bold">View My Orders</a>
                        <a href="/home" class="btn btn-danger rounded-pill px-4 fw-bold" style="background-color: var(--theme-red); border-color: var(--theme-red);">Order More Food</a>
                    </div>
                </div>
            </div>
        </div>
    </main>`;
    return renderPage(html, 'Order Confirmation - QuickBite', session);
}

function renderOrdersPage(session) {
    const user = session.user;
    const orders = DB.orders.filter(o => o.userId === user.id);

    const html = `
    <main class="container my-4">
        <div class="d-flex align-items-center justify-content-between mb-4">
            <div>
                <h1 class="fs-3 fw-bold mb-1">My Orders &amp; Tracking</h1>
                <span class="text-muted small">Track deliveries in real-time</span>
            </div>
            <a href="/home" class="btn btn-outline-danger rounded-pill px-4 fw-bold btn-sm">+ Order More</a>
        </div>

        <div class="row g-4">
            ${orders.map(order => `
                <div class="col-12">
                    <div class="card border-0 shadow-sm rounded-4 p-4 bg-white">
                        <div class="d-flex justify-content-between align-items-center pb-3 border-bottom">
                            <div>
                                <div class="fw-bold fs-6">Order #${order.orderNumber}</div>
                                <div class="text-muted small">${order.formattedDate}</div>
                            </div>
                            <div>
                                <span class="badge bg-danger px-3 py-2">${order.orderStatus}</span>
                                <span class="badge bg-light text-dark border px-3 py-2 ms-1">${order.paymentMethod}</span>
                            </div>
                        </div>

                        <div class="order-tracker-card border-0 p-0 my-3 shadow-none">
                            <div class="timeline-track">
                                <div class="timeline-progress-bar" style="width: 66%;"></div>
                                <div class="timeline-step completed"><div class="step-node">📝</div><div class="step-title">Placed</div></div>
                                <div class="timeline-step completed"><div class="step-node">🍳</div><div class="step-title">Preparing</div></div>
                                <div class="timeline-step active"><div class="step-node">🛵</div><div class="step-title">On The Way</div></div>
                                <div class="timeline-step"><div class="step-node">🏠</div><div class="step-title">Delivered</div></div>
                            </div>
                        </div>

                        <div class="bg-light rounded-3 p-3 mb-3">
                            ${order.items.map(it => `
                                <div class="d-flex justify-content-between small py-1">
                                    <span>${it.itemName} × ${it.quantity}</span>
                                    <span class="fw-bold">₹${it.totalPrice}</span>
                                </div>
                            `).join('')}
                        </div>

                        <div class="d-flex justify-content-between align-items-center">
                            <div class="small text-muted">Delivery: <strong>${order.deliveryAddressText}</strong></div>
                            <div class="fw-bold fs-5 text-dark">Total: <span class="text-danger">₹${order.totalAmount}</span></div>
                        </div>
                    </div>
                </div>
            `).join('')}
        </div>
    </main>`;
    return renderPage(html, 'My Orders - QuickBite', session);
}

function renderAdminDashboard(session) {
    const totalRev = DB.orders.filter(o => o.orderStatus !== 'CANCELLED').reduce((s, o) => s + o.totalAmount, 0);

    const html = `
    <main class="container my-4">
        <div class="d-flex justify-content-between align-items-center mb-4 pb-3 border-bottom">
            <div>
                <span class="badge bg-warning text-dark px-3 py-1 rounded-pill fw-bold">Admin Portal</span>
                <h1 class="fs-3 fw-bold mb-0 mt-1">Store Performance &amp; Operations</h1>
            </div>
            <div class="d-flex gap-2">
                <a href="/admin/orders" class="btn btn-outline-primary rounded-pill btn-sm px-3 fw-bold">Manage Orders</a>
                <a href="/admin/items" class="btn btn-outline-danger rounded-pill btn-sm px-3 fw-bold">Food Catalog</a>
            </div>
        </div>

        <div class="row g-3 mb-4">
            <div class="col-sm-6 col-lg-3"><div class="admin-card-stat"><div class="stat-icon-wrap bg-danger-subtle text-danger">💰</div><div><div class="stat-value">₹${totalRev}</div><div class="stat-label">Total Revenue</div></div></div></div>
            <div class="col-sm-6 col-lg-3"><div class="admin-card-stat"><div class="stat-icon-wrap bg-primary-subtle text-primary">📦</div><div><div class="stat-value">${DB.orders.length}</div><div class="stat-label">Total Orders</div></div></div></div>
            <div class="col-sm-6 col-lg-3"><div class="admin-card-stat"><div class="stat-icon-wrap bg-warning-subtle text-warning">🍕</div><div><div class="stat-value">${DB.foodItems.length}</div><div class="stat-label">Menu Items</div></div></div></div>
            <div class="col-sm-6 col-lg-3"><div class="admin-card-stat"><div class="stat-icon-wrap bg-info-subtle text-info">👥</div><div><div class="stat-value">${DB.users.filter(u => u.role === 'CUSTOMER').length}</div><div class="stat-label">Active Customers</div></div></div></div>
        </div>

        <div class="card border-0 shadow-sm rounded-4 p-4 bg-white">
            <h2 class="fs-5 fw-bold mb-3">Live Orders Dispatch</h2>
            <div class="table-responsive">
                <table class="table align-middle table-hover">
                    <thead class="table-light"><tr><th>Order #</th><th>Customer</th><th>Amount</th><th>Status</th><th>Action</th></tr></thead>
                    <tbody>
                        ${DB.orders.map(o => `
                            <tr>
                                <td class="fw-bold">#${o.orderNumber}</td>
                                <td>${o.customerName} (${o.customerPhone})</td>
                                <td class="fw-bold text-danger">₹${o.totalAmount}</td>
                                <td><span class="badge bg-danger px-2 py-1">${o.orderStatus}</span></td>
                                <td>
                                    <form action="/admin/orders" method="POST" class="d-inline">
                                        <input type="hidden" name="orderId" value="${o.id}">
                                        <select name="newStatus" class="form-select form-select-sm d-inline-block w-auto" onchange="this.form.submit()">
                                            <option value="PLACED" ${o.orderStatus === 'PLACED' ? 'selected' : ''}>PLACED</option>
                                            <option value="PREPARING" ${o.orderStatus === 'PREPARING' ? 'selected' : ''}>PREPARING</option>
                                            <option value="OUT_FOR_DELIVERY" ${o.orderStatus === 'OUT_FOR_DELIVERY' ? 'selected' : ''}>OUT_FOR_DELIVERY</option>
                                            <option value="DELIVERED" ${o.orderStatus === 'DELIVERED' ? 'selected' : ''}>DELIVERED</option>
                                            <option value="CANCELLED" ${o.orderStatus === 'CANCELLED' ? 'selected' : ''}>CANCELLED</option>
                                        </select>
                                    </form>
                                </td>
                            </tr>
                        `).join('')}
                    </tbody>
                </table>
            </div>
        </div>
    </main>`;
    return renderPage(html, 'Admin Dashboard - QuickBite', session);
}

function renderAdminItems(session) {
    const html = `
    <main class="container-fluid px-lg-5 my-4">
        <div class="d-flex justify-content-between align-items-center mb-4 pb-3 border-bottom">
            <div>
                <nav class="breadcrumb small mb-1"><a href="/admin/dashboard">Dashboard</a> / Items</nav>
                <h1 class="fs-3 fw-bold mb-0">Food Items Catalog (${DB.foodItems.length})</h1>
            </div>
        </div>
        <div class="card border-0 shadow-sm rounded-4 bg-white overflow-hidden">
            <div class="table-responsive">
                <table class="table align-middle table-hover mb-0">
                    <thead class="table-light"><tr><th>Image</th><th>Details</th><th>Category</th><th>Diet</th><th>Price</th><th>Stock</th></tr></thead>
                    <tbody>
                        ${DB.foodItems.map(item => `
                            <tr>
                                <td><img src="${item.imageUrl}" class="rounded-3" style="width: 50px; height: 50px; object-fit: cover;"></td>
                                <td><div class="fw-bold">${item.name}</div><div class="text-muted small">${item.unit}</div></td>
                                <td><span class="badge bg-light text-dark border">${item.categoryName}</span></td>
                                <td><span class="badge ${item.isVeg ? 'bg-success-subtle text-success' : 'bg-danger-subtle text-danger'}">${item.isVeg ? 'Veg' : 'Non-Veg'}</span></td>
                                <td class="fw-bold text-danger">₹${item.discountPrice || item.price}</td>
                                <td><span class="badge ${item.isAvailable ? 'bg-danger' : 'bg-secondary'}">${item.isAvailable ? 'In Stock' : 'Out of Stock'}</span></td>
                            </tr>
                        `).join('')}
                    </tbody>
                </table>
            </div>
        </div>
    </main>`;
    return renderPage(html, 'Manage Items - QuickBite Admin', session);
}

function renderLoginPage(session) {
    const html = `
    <main class="container my-5">
        <div class="row justify-content-center">
            <div class="col-md-5 col-lg-4">
                <div class="card border-0 shadow-sm rounded-4 p-4 bg-white">
                    <div class="text-center mb-4">
                        <div class="brand-title fs-2 mb-1">Quick<span>Bite</span></div>
                        <h1 class="fs-5 fw-bold text-dark">Craving delivered in 10 minutes</h1>
                        <p class="text-muted small">Log in to track orders, addresses and quick payments</p>
                    </div>
                    <form action="/login" method="POST">
                        <div class="mb-3">
                            <label class="form-label small fw-semibold text-muted">Email Address</label>
                            <input type="email" id="email" name="email" class="form-control rounded-3" value="user@quickbite.com" required>
                        </div>
                        <div class="mb-4">
                            <label class="form-label small fw-semibold text-muted">Password</label>
                            <input type="password" id="password" name="password" class="form-control rounded-3" value="User@123" required>
                        </div>
                        <button type="submit" class="btn btn-danger w-100 py-2 fw-bold rounded-3 mb-3" style="background-color: var(--theme-red); border-color: var(--theme-red);">Continue</button>
                    </form>
                    <div class="mt-3 pt-3 border-top text-center">
                        <div class="small fw-bold text-muted mb-2">1-Click Quick Demo Fill:</div>
                        <button class="btn btn-outline-secondary btn-sm rounded-3 w-100 mb-2" onclick="fill('admin@quickbite.com', 'Admin@123')">👑 Admin (admin@quickbite.com)</button>
                        <button class="btn btn-outline-secondary btn-sm rounded-3 w-100" onclick="fill('user@quickbite.com', 'User@123')">👤 Customer (user@quickbite.com)</button>
                    </div>
                </div>
            </div>
        </div>
    </main>
    <script>function fill(e, p){ document.getElementById('email').value=e; document.getElementById('password').value=p; }</script>`;
    return renderPage(html, 'Login - QuickBite', session);
}

// --------------------------------------------------------
// HTTP REQUEST ROUTING
// --------------------------------------------------------
function handleRequest(req, res) {
    const parsedUrl = url.parse(req.url, true);
    const pathname = parsedUrl.pathname;
    const session = getSession(req, res);

    // STATIC ASSETS (CSS / JS)
    if (pathname.startsWith('/css/') || pathname.startsWith('/js/')) {
        const filePath = path.join(WEBAPP_DIR, pathname);
        fs.readFile(filePath, (err, data) => {
            if (err) {
                res.writeHead(404);
                res.end('Not found');
            } else {
                const ext = path.extname(filePath);
                const contentType = ext === '.css' ? 'text/css' : 'application/javascript';
                res.writeHead(200, { 'Content-Type': contentType });
                res.end(data);
            }
        });
        return;
    }

    // API CART (AJAX)
    if (pathname === '/cart' || pathname === '/api/cart') {
        if (req.method === 'GET') {
            const data = calculateCartTotals(session.cart);
            res.writeHead(200, { 'Content-Type': 'application/json' });
            res.end(JSON.stringify(data));
            return;
        }

        if (req.method === 'POST') {
            let body = '';
            req.on('data', chunk => body += chunk);
            req.on('end', () => {
                const params = querystring.parse(body);
                const action = params.action || 'get';
                const foodId = parseInt(params.foodId);
                const qty = parseInt(params.qty || 1);

                if (action === 'add') {
                    const item = DB.foodItems.find(f => f.id === foodId);
                    if (item) {
                        const existing = session.cart.get(foodId) || { item, quantity: 0 };
                        existing.quantity += qty;
                        session.cart.set(foodId, existing);
                    }
                } else if (action === 'update') {
                    if (qty <= 0) {
                        session.cart.delete(foodId);
                    } else if (session.cart.has(foodId)) {
                        session.cart.get(foodId).quantity = qty;
                    }
                } else if (action === 'remove') {
                    session.cart.delete(foodId);
                } else if (action === 'clear') {
                    session.cart.clear();
                }

                const data = calculateCartTotals(session.cart);
                res.writeHead(200, { 'Content-Type': 'application/json' });
                res.end(JSON.stringify({ success: true, message: 'Cart updated', data }));
            });
            return;
        }
    }

    // API SEARCH SUGGESTIONS (AJAX)
    if (pathname === '/api/search') {
        const q = (parsedUrl.query.q || '').toLowerCase();
        const results = DB.foodItems
            .filter(f => f.isAvailable && (f.name.toLowerCase().includes(q) || f.categoryName.toLowerCase().includes(q)))
            .slice(0, 8)
            .map(f => ({
                id: f.id,
                name: f.name,
                categoryName: f.categoryName,
                price: f.discountPrice || f.price,
                unit: f.unit,
                imageUrl: f.imageUrl,
                isVeg: f.isVeg
            }));
        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify(results));
        return;
    }

    // POST CHECKOUT
    if (pathname === '/checkout' && req.method === 'POST') {
        let body = '';
        req.on('data', chunk => body += chunk);
        req.on('end', () => {
            const params = querystring.parse(body);
            const totals = calculateCartTotals(session.cart);
            const orderNum = 'QKB-' + Date.now().toString().slice(-8);

            const newOrder = {
                id: DB.orders.length + 1,
                orderNumber: orderNum,
                userId: session.user ? session.user.id : 2,
                customerName: session.user ? session.user.name : 'Customer',
                customerPhone: session.user ? session.user.phone : '+91 9876543210',
                deliveryAddressText: 'Flat 402, Green Glen Heights, Outer Ring Road, Bellandur, Bengaluru',
                subtotal: totals.subtotal,
                deliveryFee: totals.deliveryFee,
                handlingFee: totals.handlingFee,
                totalAmount: totals.grandTotal,
                paymentMethod: params.paymentMethod || 'UPI',
                paymentStatus: params.paymentMethod === 'COD' ? 'PENDING' : 'PAID',
                orderStatus: 'PLACED',
                estimatedDeliveryMins: 12,
                formattedDate: new Date().toLocaleDateString('en-GB', { day: '2-digit', month: 'short', year: 'numeric', hour: '2-digit', minute: '2-digit' }),
                items: totals.items.map((it, idx) => ({
                    id: idx + 1,
                    foodItemId: it.id,
                    itemName: it.name,
                    price: it.effectivePrice,
                    quantity: it.quantity,
                    totalPrice: it.itemTotal
                }))
            };

            DB.orders.unshift(newOrder);
            session.cart.clear();

            res.writeHead(302, { 'Location': `/order-confirmation?orderNumber=${orderNum}` });
            res.end();
        });
        return;
    }

    // POST LOGIN
    if (pathname === '/login' && req.method === 'POST') {
        let body = '';
        req.on('data', chunk => body += chunk);
        req.on('end', () => {
            const params = querystring.parse(body);
            const inputEmail = (params.email || '').toLowerCase().trim();
            const u = DB.users.find(usr => 
                (usr.email.toLowerCase() === inputEmail || 
                 usr.email.toLowerCase().replace('@quickbite.com', '@blinkit.com') === inputEmail ||
                 usr.email.toLowerCase().replace('@blinkit.com', '@quickbite.com') === inputEmail) && 
                usr.password === params.password
            );
            if (u) {
                session.user = u;
                res.writeHead(302, { 'Location': u.role === 'ADMIN' ? '/admin/dashboard' : '/home' });
            } else {
                res.writeHead(302, { 'Location': '/login?error=Invalid credentials' });
            }
            res.end();
        });
        return;
    }

    // LOGOUT
    if (pathname === '/logout') {
        session.user = null;
        res.writeHead(302, { 'Location': '/home' });
        res.end();
        return;
    }

    // ADMIN UPDATE ORDER STATUS
    if (pathname === '/admin/orders' && req.method === 'POST') {
        let body = '';
        req.on('data', chunk => body += chunk);
        req.on('end', () => {
            const params = querystring.parse(body);
            const orderId = parseInt(params.orderId);
            const ord = DB.orders.find(o => o.id === orderId);
            if (ord) ord.orderStatus = params.newStatus;
            res.writeHead(302, { 'Location': '/admin/dashboard' });
            res.end();
        });
        return;
    }

    // HTML PAGES & ROUTING
    if (pathname === '/' || pathname === '/home' || pathname === '/index' || pathname === '/food-ordering-system' || pathname === '/food-ordering-system/') {
        res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
        res.end(renderHomePage(session));
    } else if (pathname === '/search') {
        res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
        res.end(renderSearchPage(parsedUrl.query.q, parsedUrl.query.cat, session));
    } else if (pathname === '/checkout') {
        res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
        res.end(renderCheckoutPage(session));
    } else if (pathname === '/order-confirmation') {
        res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
        res.end(renderOrderConfirmationPage(parsedUrl.query.orderNumber, session));
    } else if (pathname === '/orders') {
        res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
        res.end(renderOrdersPage(session));
    } else if (pathname === '/admin' || pathname === '/admin/dashboard') {
        res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
        res.end(renderAdminDashboard(session));
    } else if (pathname === '/admin/items') {
        res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
        res.end(renderAdminItems(session));
    } else if (pathname === '/login') {
        res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
        res.end(renderLoginPage(session));
    } else {
        res.writeHead(302, { 'Location': '/home' });
        res.end();
    }
}

const server = http.createServer(handleRequest);

if (require.main === module) {
    server.listen(PORT, () => {
        console.log(`========================================================`);
        console.log(`🚀 QUICKBITE FOOD ORDERING SYSTEM IS LIVE!`);
        console.log(`🌐 Local URL: http://localhost:${PORT}/`);
        console.log(`✨ Theme: Vibrant Red (#E23744) | Fake In-Memory DB`);
        console.log(`========================================================`);
    });
}

module.exports = handleRequest;
