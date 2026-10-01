-- ===================================================
-- Blinkit Online Food Ordering System
-- Seed Data (24+ Food Items, Categories, Admins, Users)
-- ===================================================

USE food_ordering_db;

-- 1. Insert Categories
INSERT INTO categories (id, name, slug, description, image_url, display_order) VALUES
(1, 'Pizza', 'pizza', 'Hot, crispy, cheesy pizzas loaded with fresh toppings', 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=500&auto=format&fit=crop&q=80', 1),
(2, 'Burgers & Wraps', 'burgers-wraps', 'Juicy grilled patties, crispy crunches and soft toasted buns', 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500&auto=format&fit=crop&q=80', 2),
(3, 'Biryani & Bowls', 'biryani-bowls', 'Aromatic royal biryanis slow-cooked with exotic spices', 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=500&auto=format&fit=crop&q=80', 3),
(4, 'Quick Snacks & Fries', 'snacks-fries', 'Golden fries, nuggets, crunchy bites for evening cravings', 'https://images.unsplash.com/photo-1576107232684-1279f3908594?w=500&auto=format&fit=crop&q=80', 4),
(5, 'Desserts & Sweet Bites', 'desserts', 'Warm lava cakes, artisanal ice creams and traditional sweets', 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=500&auto=format&fit=crop&q=80', 5),
(6, 'Beverages & Shakes', 'beverages', 'Thick fruit shakes, chilled cold coffee and fizzy refreshers', 'https://images.unsplash.com/photo-1517256064527-09c73fc73e38?w=500&auto=format&fit=crop&q=80', 6),
(7, 'Asian & Noodles', 'asian-noodles', 'Wok-tossed Hakka noodles, fried rice and crispy spring rolls', 'https://images.unsplash.com/photo-1585032226651-759b368d7246?w=500&auto=format&fit=crop&q=80', 7);

-- 2. Insert Users (Admin & Customers)
-- Passwords are hashed using SHA-256:
-- Admin: Admin@123
-- User:  User@123
INSERT INTO users (id, name, email, password_hash, phone, role) VALUES
(1, 'Blinkit Super Admin', 'admin@blinkit.com', SHA2('Admin@123', 256), '+91 9876543210', 'ADMIN'),
(2, 'Rahul Sharma', 'user@blinkit.com', SHA2('User@123', 256), '+91 9123456780', 'CUSTOMER'),
(3, 'Priya Patel', 'priya@gmail.com', SHA2('User@123', 256), '+91 9898989898', 'CUSTOMER');

-- 3. Insert User Addresses
INSERT INTO addresses (id, user_id, address_type, address_line1, address_line2, landmark, city, state, pincode, is_default) VALUES
(1, 2, 'Home', 'Flat 402, Green Glen Heights', 'Outer Ring Road, Bellandur', 'Near EcoSpace Tech Park', 'Bengaluru', 'Karnataka', '560103', TRUE),
(2, 2, 'Work', 'Tower B, 7th Floor, RMZ Infinity', 'Old Madras Road', 'Opposite Gopalan Mall', 'Bengaluru', 'Karnataka', '560016', FALSE),
(3, 3, 'Home', 'B-12, Shanti Kunj Apartments', '100ft Road, Indiranagar', 'Near Metro Station', 'Bengaluru', 'Karnataka', '560038', TRUE);

-- 4. Insert 24 Food Items Across All Categories
INSERT INTO food_items (id, category_id, name, description, price, discount_price, unit, image_url, is_veg, is_popular, is_available, rating, delivery_time_mins) VALUES
-- Category 1: Pizza
(1, 1, 'Margherita Cheese Pizza', 'Authentic Italian tomato herb sauce topped with melted 100% Mozzarella cheese on a crisp crust.', 249.00, 199.00, 'Regular (7 inch)', 'https://images.unsplash.com/photo-1604382354936-07c5d9983bd3?w=500&auto=format&fit=crop&q=80', TRUE, TRUE, TRUE, 4.8, 10),
(2, 1, 'Farmhouse Supreme Pizza', 'Crunchy bell peppers, red paprika, sliced black olives, sweet corn kernels and roasted red onions.', 399.00, 329.00, 'Medium (10 inch)', 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=500&auto=format&fit=crop&q=80', TRUE, TRUE, TRUE, 4.7, 12),
(3, 1, 'Smoky BBQ Chicken Pizza', 'Tender grilled chicken chunks infused with smoky Texas BBQ sauce, jalapeños and mozzarella.', 449.00, 379.00, 'Medium (10 inch)', 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=500&auto=format&fit=crop&q=80', FALSE, TRUE, TRUE, 4.9, 14),
(4, 1, 'Paneer Tikka Stuffed Crust', 'Marinated charcoal-spiced cottage cheese cubes, fresh capsicum, mint drizzle, cheese-filled crust.', 429.00, 359.00, 'Medium (10 inch)', 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=500&auto=format&fit=crop&q=80', TRUE, FALSE, TRUE, 4.6, 12),

-- Category 2: Burgers & Wraps
(5, 2, 'Crispy Veggie Crunch Burger', 'Golden spiced potato & pea patty, signature garlic aioli, crunchy iceberg lettuce in a toasted sesame bun.', 129.00, 89.00, '1 pc (180g)', 'https://images.unsplash.com/photo-1550547660-d9450f859349?w=500&auto=format&fit=crop&q=80', TRUE, TRUE, TRUE, 4.6, 10),
(6, 2, 'Grilled Chicken Maharaja Burger', 'Double juicy grilled chicken patties with melted cheese slice, tangy pickle relish and habanero sauce.', 239.00, 189.00, '1 pc (240g)', 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500&auto=format&fit=crop&q=80', FALSE, TRUE, TRUE, 4.8, 12),
(7, 2, 'Paneer Kathi Roll', 'Pan-seared spiced paneer cubes tossed with crunchy onions and mint-coriander dip rolled in flaky paratha.', 169.00, 139.00, '1 roll (220g)', 'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?w=500&auto=format&fit=crop&q=80', TRUE, FALSE, TRUE, 4.5, 10),
(8, 2, 'Double Egg & Chicken Wrap', 'Smoked succulent chicken strips enveloped with fluffy double egg omelette, peri-peri mayonnaise.', 209.00, 169.00, '1 roll (260g)', 'https://images.unsplash.com/photo-1528735602780-2552fd46c7af?w=500&auto=format&fit=crop&q=80', FALSE, TRUE, TRUE, 4.7, 12),

-- Category 3: Biryani & Bowls
(9, 3, 'Hyderabadi Dum Chicken Biryani', 'Slow-cooked aromatic basmati rice with succulent bone-in chicken marinated in secret Hyderabadi spices. Served with creamy raita.', 349.00, 299.00, 'Serves 1-2 (550g)', 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=500&auto=format&fit=crop&q=80', FALSE, TRUE, TRUE, 4.9, 15),
(10, 3, 'Royal Lucknowi Veg Dum Biryani', 'Fragrant long-grain basmati layered with farm-fresh veggies, saffron milk, fried cashews and caramelised onions.', 279.00, 229.00, 'Serves 1-2 (500g)', 'https://images.unsplash.com/photo-1645177628172-a94c1f96e6db?w=500&auto=format&fit=crop&q=80', TRUE, TRUE, TRUE, 4.7, 12),
(11, 3, 'Tandoori Paneer Makhani Rice Bowl', 'Smoky char-grilled paneer cubes simmered in creamy makhani gravy served atop steaming cumin-spiced basmati.', 269.00, 219.00, 'Serves 1 (420g)', 'https://images.unsplash.com/photo-1589302168068-964664d93dc0?w=500&auto=format&fit=crop&q=80', TRUE, FALSE, TRUE, 4.6, 10),
(12, 3, 'Butter Chicken Rice Bowl', 'Classic tender tandoori chicken cooked in rich silky tomato-butter gravy paired with fragrant steamed rice.', 319.00, 269.00, 'Serves 1 (450g)', 'https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?w=500&auto=format&fit=crop&q=80', FALSE, TRUE, TRUE, 4.8, 12),

-- Category 4: Quick Snacks & Fries
(13, 4, 'Crispy Golden French Fries', 'Deep fried crisp golden potato batons lightly salted. Perfectly crunchy on the outside, fluffy inside.', 109.00, 79.00, 'Regular (150g)', 'https://images.unsplash.com/photo-1576107232684-1279f3908594?w=500&auto=format&fit=crop&q=80', TRUE, TRUE, TRUE, 4.5, 8),
(14, 4, 'Peri Peri Cheese Crusted Fries', 'Crispy fries dusted with hot African peri-peri seasoning and drenched with warm cheddar cheese drizzle.', 149.00, 119.00, 'Large (200g)', 'https://images.unsplash.com/photo-1585109649139-366815a0d713?w=500&auto=format&fit=crop&q=80', TRUE, TRUE, TRUE, 4.8, 10),
(15, 4, 'Crunchy Mozzarella Sticks (6 Pcs)', 'Breadcrumb crusted stringy mozzarella cheese fingers served with zesty Italian tomato marinara dip.', 189.00, 149.00, '6 pcs (160g)', 'https://images.unsplash.com/photo-1531749668029-2db88e4276c7?w=500&auto=format&fit=crop&q=80', TRUE, FALSE, TRUE, 4.7, 10),
(16, 4, 'Crispy Chicken Popcorn', 'Bite-sized pieces of boneless tender chicken enveloped in ultra-crunchy seasoned southern batter.', 219.00, 179.00, '1 Tub (180g)', 'https://images.unsplash.com/photo-1562967914-608f82629710?w=500&auto=format&fit=crop&q=80', FALSE, TRUE, TRUE, 4.8, 10),

-- Category 5: Desserts & Sweet Bites
(17, 5, 'Warm Chocolate Lava Cake', 'Rich chocolate sponge cake with an irresistible warm molten dark chocolate center that oozes out upon cut.', 119.00, 89.00, '1 pc (90g)', 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=500&auto=format&fit=crop&q=80', TRUE, TRUE, TRUE, 4.9, 8),
(18, 5, 'Belgian Dark Chocolate Ice Cream', 'Creamy churned premium chocolate ice cream folded with bittersweet Belgian fudge chocolate chips.', 139.00, 109.00, '1 Tub (125ml)', 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=500&auto=format&fit=crop&q=80', TRUE, TRUE, TRUE, 4.8, 8),
(19, 5, 'Hot Gulab Jamun with Rabdi (2 Pcs)', 'Khoya dumplings deep-fried and soaked in rose-cardamom syrup, served hot with chilled creamy rabdi.', 129.00, 99.00, '2 pcs (140g)', 'https://images.unsplash.com/photo-1599785209707-a456fc1337bb?w=500&auto=format&fit=crop&q=80', TRUE, FALSE, TRUE, 4.7, 8),
(20, 5, 'Red Velvet Cream Cheese Jar Cake', 'Layers of crimson cocoa sponge interspersed with luscious Philadelphia cream cheese frosting in a jar.', 149.00, 119.00, '1 Jar (150g)', 'https://images.unsplash.com/photo-1586985289688-ca3cf47d3e6e?w=500&auto=format&fit=crop&q=80', TRUE, FALSE, TRUE, 4.7, 8),

-- Category 6: Beverages & Shakes
(21, 6, 'Classic Cold Coffee Frappe', 'Double shot of roasted Arabica espresso blended with chilled milk, sugar syrup and rich vanilla ice cream.', 129.00, 99.00, '300 ml', 'https://images.unsplash.com/photo-1517256064527-09c73fc73e38?w=500&auto=format&fit=crop&q=80', TRUE, TRUE, TRUE, 4.8, 8),
(22, 6, 'Ratnagiri Alphonso Mango Shake', 'Made with real seasonal Alphonso mango pulp, chilled whole milk and topped with diced fresh mango bits.', 159.00, 129.00, '300 ml', 'https://images.unsplash.com/photo-1623065422902-30a2d299bbe4?w=500&auto=format&fit=crop&q=80', TRUE, TRUE, TRUE, 4.9, 8),
(23, 6, 'Fresh Mint Mojito Cooler', 'Crushed garden-fresh spearmint leaves, tart lime wedges, sparkling club soda and a dash of cane sugar.', 109.00, 79.00, '350 ml', 'https://images.unsplash.com/photo-1551024709-8f23befc6f87?w=500&auto=format&fit=crop&q=80', TRUE, FALSE, TRUE, 4.6, 8),

-- Category 7: Asian & Noodles
(24, 7, 'Veg Hakka Chowmein Noodles', 'Wok-tossed noodles with shredded purple cabbage, carrots, bell peppers, scallions and soy-chili sauce.', 199.00, 159.00, 'Serves 1-2 (420g)', 'https://images.unsplash.com/photo-1585032226651-759b368d7246?w=500&auto=format&fit=crop&q=80', TRUE, TRUE, TRUE, 4.6, 12);

-- 5. Insert Sample Order
INSERT INTO orders (id, order_number, user_id, address_id, delivery_address_text, customer_name, customer_phone, subtotal, delivery_fee, handling_fee, total_amount, payment_method, payment_status, order_status, estimated_delivery_mins) VALUES
(1, 'BLK-20261001-9841', 2, 1, 'Flat 402, Green Glen Heights, Outer Ring Road, Bellandur, Bengaluru, 560103', 'Rahul Sharma', '+91 9123456780', 288.00, 0.00, 4.00, 292.00, 'UPI', 'PAID', 'OUT_FOR_DELIVERY', 10);

INSERT INTO order_items (order_id, food_item_id, item_name, price, quantity, total_price) VALUES
(1, 1, 'Margherita Cheese Pizza', 199.00, 1, 199.00),
(1, 5, 'Crispy Veggie Crunch Burger', 89.00, 1, 89.00);
