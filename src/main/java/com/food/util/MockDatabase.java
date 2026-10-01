package com.food.util;

import com.food.model.*;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.Collectors;

/**
 * High-performance, thread-safe In-Memory Fake Database.
 * Pre-seeded with categories, 24+ food items, users, addresses, and orders.
 * Zero external database or MySQL setup required!
 */
public class MockDatabase {

    private static final MockDatabase INSTANCE = new MockDatabase();

    public static MockDatabase getInstance() {
        return INSTANCE;
    }

    private final Map<Integer, User> usersById = new ConcurrentHashMap<>();
    private final Map<String, User> usersByEmail = new ConcurrentHashMap<>();

    private final Map<Integer, Category> categoriesById = new ConcurrentHashMap<>();
    private final Map<Integer, FoodItem> foodItemsById = new ConcurrentHashMap<>();

    private final Map<Integer, Address> addressesById = new ConcurrentHashMap<>();
    private final Map<Integer, Order> ordersById = new ConcurrentHashMap<>();
    private final Map<String, Order> ordersByNumber = new ConcurrentHashMap<>();
    private final Map<Integer, List<OrderItem>> orderItemsByOrderId = new ConcurrentHashMap<>();

    private final AtomicInteger userIdGen = new AtomicInteger(10);
    private final AtomicInteger categoryIdGen = new AtomicInteger(10);
    private final AtomicInteger foodIdGen = new AtomicInteger(50);
    private final AtomicInteger addressIdGen = new AtomicInteger(10);
    private final AtomicInteger orderIdGen = new AtomicInteger(10);
    private final AtomicInteger orderItemIdGen = new AtomicInteger(50);

    private MockDatabase() {
        seedInitialData();
    }

    private void seedInitialData() {
        // 1. Seed Categories
        addSeedCategory(1, "Pizza", "pizza", "Hot, crispy, cheesy pizzas loaded with fresh toppings", "https://images.unsplash.com/photo-1513104890138-7c749659a591?w=500&auto=format&fit=crop&q=80", 1);
        addSeedCategory(2, "Burgers & Wraps", "burgers-wraps", "Juicy grilled patties, crispy crunches and soft toasted buns", "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500&auto=format&fit=crop&q=80", 2);
        addSeedCategory(3, "Biryani & Bowls", "biryani-bowls", "Aromatic royal biryanis slow-cooked with exotic spices", "https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=500&auto=format&fit=crop&q=80", 3);
        addSeedCategory(4, "Quick Snacks & Fries", "snacks-fries", "Golden fries, nuggets, crunchy bites for evening cravings", "https://images.unsplash.com/photo-1576107232684-1279f3908594?w=500&auto=format&fit=crop&q=80", 4);
        addSeedCategory(5, "Desserts & Sweet Bites", "desserts", "Warm lava cakes, artisanal ice creams and traditional sweets", "https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=500&auto=format&fit=crop&q=80", 5);
        addSeedCategory(6, "Beverages & Shakes", "beverages", "Thick fruit shakes, chilled cold coffee and fizzy refreshers", "https://images.unsplash.com/photo-1517256064527-09c73fc73e38?w=500&auto=format&fit=crop&q=80", 6);
        addSeedCategory(7, "Asian & Noodles", "asian-noodles", "Wok-tossed Hakka noodles, fried rice and crispy spring rolls", "https://images.unsplash.com/photo-1585032226651-759b368d7246?w=500&auto=format&fit=crop&q=80", 7);

        // 2. Seed Users
        addSeedUser(1, "Quickbite Super Admin", "admin@quickbite.com", PasswordUtil.hashPassword("Admin@123"), "+91 9876543210", "ADMIN");
        addSeedUser(2, "Rahul Sharma", "user@quickbite.com", PasswordUtil.hashPassword("User@123"), "+91 9123456780", "CUSTOMER");
        addSeedUser(3, "Priya Patel", "priya@gmail.com", PasswordUtil.hashPassword("User@123"), "+91 9898989898", "CUSTOMER");

        // 3. Seed Addresses
        addSeedAddress(1, 2, "Home", "Flat 402, Green Glen Heights", "Outer Ring Road, Bellandur", "Near EcoSpace Tech Park", "Bengaluru", "Karnataka", "560103", true);
        addSeedAddress(2, 2, "Work", "Tower B, 7th Floor, RMZ Infinity", "Old Madras Road", "Opposite Gopalan Mall", "Bengaluru", "Karnataka", "560016", false);
        addSeedAddress(3, 3, "Home", "B-12, Shanti Kunj Apartments", "100ft Road, Indiranagar", "Near Metro Station", "Bengaluru", "Karnataka", "560038", true);

        // 4. Seed 24 Food Items
        // Pizza (Cat 1)
        addSeedFood(1, 1, "Margherita Cheese Pizza", "Authentic Italian tomato herb sauce topped with melted 100% Mozzarella cheese on a crisp crust.", "249.00", "199.00", "Regular (7 inch)", "https://images.unsplash.com/photo-1604382354936-07c5d9983bd3?w=500&auto=format&fit=crop&q=80", true, true, 4.8, 10);
        addSeedFood(2, 1, "Farmhouse Supreme Pizza", "Crunchy bell peppers, red paprika, sliced black olives, sweet corn kernels and roasted red onions.", "399.00", "329.00", "Medium (10 inch)", "https://images.unsplash.com/photo-1513104890138-7c749659a591?w=500&auto=format&fit=crop&q=80", true, true, 4.7, 12);
        addSeedFood(3, 1, "Smoky BBQ Chicken Pizza", "Tender grilled chicken chunks infused with smoky Texas BBQ sauce, jalapeños and mozzarella.", "449.00", "379.00", "Medium (10 inch)", "https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=500&auto=format&fit=crop&q=80", false, true, 4.9, 14);
        addSeedFood(4, 1, "Paneer Tikka Stuffed Crust", "Marinated charcoal-spiced cottage cheese cubes, fresh capsicum, mint drizzle, cheese-filled crust.", "429.00", "359.00", "Medium (10 inch)", "https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=500&auto=format&fit=crop&q=80", true, false, 4.6, 12);

        // Burgers & Wraps (Cat 2)
        addSeedFood(5, 2, "Crispy Veggie Crunch Burger", "Golden spiced potato & pea patty, signature garlic aioli, crunchy iceberg lettuce in a toasted sesame bun.", "129.00", "89.00", "1 pc (180g)", "https://images.unsplash.com/photo-1550547660-d9450f859349?w=500&auto=format&fit=crop&q=80", true, true, 4.6, 10);
        addSeedFood(6, 2, "Grilled Chicken Maharaja Burger", "Double juicy grilled chicken patties with melted cheese slice, tangy pickle relish and habanero sauce.", "239.00", "189.00", "1 pc (240g)", "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500&auto=format&fit=crop&q=80", false, true, 4.8, 12);
        addSeedFood(7, 2, "Paneer Kathi Roll", "Pan-seared spiced paneer cubes tossed with crunchy onions and mint-coriander dip rolled in flaky paratha.", "169.00", "139.00", "1 roll (220g)", "https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?w=500&auto=format&fit=crop&q=80", true, false, 4.5, 10);
        addSeedFood(8, 2, "Double Egg & Chicken Wrap", "Smoked succulent chicken strips enveloped with fluffy double egg omelette, peri-peri mayonnaise.", "209.00", "169.00", "1 roll (260g)", "https://images.unsplash.com/photo-1528735602780-2552fd46c7af?w=500&auto=format&fit=crop&q=80", false, true, 4.7, 12);

        // Biryani & Bowls (Cat 3)
        addSeedFood(9, 3, "Hyderabadi Dum Chicken Biryani", "Slow-cooked aromatic basmati rice with succulent bone-in chicken marinated in secret spices. Served with raita.", "349.00", "299.00", "Serves 1-2 (550g)", "https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=500&auto=format&fit=crop&q=80", false, true, 4.9, 15);
        addSeedFood(10, 3, "Royal Lucknowi Veg Dum Biryani", "Fragrant long-grain basmati layered with farm-fresh veggies, saffron milk, fried cashews and caramelised onions.", "279.00", "229.00", "Serves 1-2 (500g)", "https://images.unsplash.com/photo-1645177628172-a94c1f96e6db?w=500&auto=format&fit=crop&q=80", true, true, 4.7, 12);
        addSeedFood(11, 3, "Tandoori Paneer Makhani Rice Bowl", "Smoky char-grilled paneer cubes simmered in creamy makhani gravy served atop steaming cumin-spiced basmati.", "269.00", "219.00", "Serves 1 (420g)", "https://images.unsplash.com/photo-1589302168068-964664d93dc0?w=500&auto=format&fit=crop&q=80", true, false, 4.6, 10);
        addSeedFood(12, 3, "Butter Chicken Rice Bowl", "Classic tender tandoori chicken cooked in rich silky tomato-butter gravy paired with fragrant steamed rice.", "319.00", "269.00", "Serves 1 (450g)", "https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?w=500&auto=format&fit=crop&q=80", false, true, 4.8, 12);

        // Quick Snacks & Fries (Cat 4)
        addSeedFood(13, 4, "Crispy Golden French Fries", "Deep fried crisp golden potato batons lightly salted. Perfectly crunchy on the outside, fluffy inside.", "109.00", "79.00", "Regular (150g)", "https://images.unsplash.com/photo-1576107232684-1279f3908594?w=500&auto=format&fit=crop&q=80", true, true, 4.5, 8);
        addSeedFood(14, 4, "Peri Peri Cheese Crusted Fries", "Crispy fries dusted with hot African peri-peri seasoning and drenched with warm cheddar cheese drizzle.", "149.00", "119.00", "Large (200g)", "https://images.unsplash.com/photo-1585109649139-366815a0d713?w=500&auto=format&fit=crop&q=80", true, true, 4.8, 10);
        addSeedFood(15, 4, "Crunchy Mozzarella Sticks (6 Pcs)", "Breadcrumb crusted stringy mozzarella cheese fingers served with zesty Italian tomato marinara dip.", "189.00", "149.00", "6 pcs (160g)", "https://images.unsplash.com/photo-1531749668029-2db88e4276c7?w=500&auto=format&fit=crop&q=80", true, false, 4.7, 10);
        addSeedFood(16, 4, "Crispy Chicken Popcorn", "Bite-sized pieces of boneless tender chicken enveloped in ultra-crunchy seasoned southern batter.", "219.00", "179.00", "1 Tub (180g)", "https://images.unsplash.com/photo-1562967914-608f82629710?w=500&auto=format&fit=crop&q=80", false, true, 4.8, 10);

        // Desserts & Sweet Bites (Cat 5)
        addSeedFood(17, 5, "Warm Chocolate Lava Cake", "Rich chocolate sponge cake with an irresistible warm molten dark chocolate center that oozes out upon cut.", "119.00", "89.00", "1 pc (90g)", "https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=500&auto=format&fit=crop&q=80", true, true, 4.9, 8);
        addSeedFood(18, 5, "Belgian Dark Chocolate Ice Cream", "Creamy churned premium chocolate ice cream folded with bittersweet Belgian fudge chocolate chips.", "139.00", "109.00", "1 Tub (125ml)", "https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=500&auto=format&fit=crop&q=80", true, true, 4.8, 8);
        addSeedFood(19, 5, "Hot Gulab Jamun with Rabdi (2 Pcs)", "Khoya dumplings deep-fried and soaked in rose-cardamom syrup, served hot with chilled creamy rabdi.", "129.00", "99.00", "2 pcs (140g)", "https://images.unsplash.com/photo-1599785209707-a456fc1337bb?w=500&auto=format&fit=crop&q=80", true, false, 4.7, 8);
        addSeedFood(20, 5, "Red Velvet Cream Cheese Jar Cake", "Layers of crimson cocoa sponge interspersed with luscious Philadelphia cream cheese frosting in a jar.", "149.00", "119.00", "1 Jar (150g)", "https://images.unsplash.com/photo-1586985289688-ca3cf47d3e6e?w=500&auto=format&fit=crop&q=80", true, false, 4.7, 8);

        // Beverages & Shakes (Cat 6)
        addSeedFood(21, 6, "Classic Cold Coffee Frappe", "Double shot of roasted Arabica espresso blended with chilled milk, sugar syrup and rich vanilla ice cream.", "129.00", "99.00", "300 ml", "https://images.unsplash.com/photo-1517256064527-09c73fc73e38?w=500&auto=format&fit=crop&q=80", true, true, 4.8, 8);
        addSeedFood(22, 6, "Ratnagiri Alphonso Mango Shake", "Made with real seasonal Alphonso mango pulp, chilled whole milk and topped with diced fresh mango bits.", "159.00", "129.00", "300 ml", "https://images.unsplash.com/photo-1623065422902-30a2d299bbe4?w=500&auto=format&fit=crop&q=80", true, true, 4.9, 8);
        addSeedFood(23, 6, "Fresh Mint Mojito Cooler", "Crushed garden-fresh spearmint leaves, tart lime wedges, sparkling club soda and a dash of cane sugar.", "109.00", "79.00", "350 ml", "https://images.unsplash.com/photo-1551024709-8f23befc6f87?w=500&auto=format&fit=crop&q=80", true, false, 4.6, 8);

        // Asian & Noodles (Cat 7)
        addSeedFood(24, 7, "Veg Hakka Chowmein Noodles", "Wok-tossed noodles with shredded purple cabbage, carrots, bell peppers, scallions and soy-chili sauce.", "199.00", "159.00", "Serves 1-2 (420g)", "https://images.unsplash.com/photo-1585032226651-759b368d7246?w=500&auto=format&fit=crop&q=80", true, true, 4.6, 12);

        // 5. Seed Initial Order
        Order sampleOrder = new Order();
        sampleOrder.setId(1);
        sampleOrder.setOrderNumber("QKB-20261001-9841");
        sampleOrder.setUserId(2);
        sampleOrder.setAddressId(1);
        sampleOrder.setDeliveryAddressText("Flat 402, Green Glen Heights, Outer Ring Road, Bellandur, Bengaluru - 560103");
        sampleOrder.setCustomerName("Rahul Sharma");
        sampleOrder.setCustomerPhone("+91 9123456780");
        sampleOrder.setSubtotal(new BigDecimal("288.00"));
        sampleOrder.setDeliveryFee(BigDecimal.ZERO);
        sampleOrder.setHandlingFee(new BigDecimal("4.00"));
        sampleOrder.setTotalAmount(new BigDecimal("292.00"));
        sampleOrder.setPaymentMethod("UPI");
        sampleOrder.setPaymentStatus("PAID");
        sampleOrder.setOrderStatus(Order.STATUS_OUT_FOR_DELIVERY);
        sampleOrder.setEstimatedDeliveryMins(10);
        sampleOrder.setCreatedAt(new Timestamp(System.currentTimeMillis() - 15 * 60 * 1000));

        List<OrderItem> items = new ArrayList<>();
        items.add(new OrderItem(1, 1, 1, "Margherita Cheese Pizza", new BigDecimal("199.00"), 1, new BigDecimal("199.00")));
        items.add(new OrderItem(2, 1, 5, "Crispy Veggie Crunch Burger", new BigDecimal("89.00"), 1, new BigDecimal("89.00")));
        sampleOrder.setItems(items);

        ordersById.put(1, sampleOrder);
        ordersByNumber.put(sampleOrder.getOrderNumber(), sampleOrder);
        orderItemsByOrderId.put(1, new CopyOnWriteArrayList<>(items));
    }

    private void addSeedCategory(int id, String name, String slug, String desc, String img, int order) {
        Category c = new Category(id, name, slug, desc, img, order, true);
        c.setCreatedAt(new Timestamp(System.currentTimeMillis()));
        categoriesById.put(id, c);
    }

    private void addSeedUser(int id, String name, String email, String passHash, String phone, String role) {
        User u = new User(id, name, email, passHash, phone, role);
        u.setCreatedAt(new Timestamp(System.currentTimeMillis()));
        usersById.put(id, u);
        usersByEmail.put(email.toLowerCase(), u);
    }

    private void addSeedAddress(int id, int userId, String type, String l1, String l2, String landmark, String city, String state, String pin, boolean isDef) {
        Address a = new Address();
        a.setId(id);
        a.setUserId(userId);
        a.setAddressType(type);
        a.setAddressLine1(l1);
        a.setAddressLine2(l2);
        a.setLandmark(landmark);
        a.setCity(city);
        a.setState(state);
        a.setPincode(pin);
        a.setDefault(isDef);
        a.setCreatedAt(new Timestamp(System.currentTimeMillis()));
        addressesById.put(id, a);
    }

    private void addSeedFood(int id, int catId, String name, String desc, String price, String discountPrice, String unit, String img, boolean isVeg, boolean isPop, double rating, int mins) {
        FoodItem f = new FoodItem();
        f.setId(id);
        f.setCategoryId(catId);
        Category c = categoriesById.get(catId);
        f.setCategoryName(c != null ? c.getName() : "");
        f.setName(name);
        f.setDescription(desc);
        f.setPrice(new BigDecimal(price));
        if (discountPrice != null) f.setDiscountPrice(new BigDecimal(discountPrice));
        f.setUnit(unit);
        f.setImageUrl(img);
        f.setVeg(isVeg);
        f.setPopular(isPop);
        f.setAvailable(true);
        f.setRating(rating);
        f.setDeliveryTimeMins(mins);
        f.setCreatedAt(new Timestamp(System.currentTimeMillis()));
        foodItemsById.put(id, f);
    }

    // ==========================================
    // USER OPERATIONS
    // ==========================================
    public User getUserByEmail(String email) {
        if (email == null) return null;
        return usersByEmail.get(email.trim().toLowerCase());
    }

    public User getUserById(int id) {
        return usersById.get(id);
    }

    public boolean emailExists(String email) {
        if (email == null) return false;
        return usersByEmail.containsKey(email.trim().toLowerCase());
    }

    public synchronized boolean addUser(User user) {
        if (user == null || emailExists(user.getEmail())) return false;
        int id = userIdGen.incrementAndGet();
        user.setId(id);
        user.setCreatedAt(new Timestamp(System.currentTimeMillis()));
        usersById.put(id, user);
        usersByEmail.put(user.getEmail().trim().toLowerCase(), user);
        return true;
    }

    public int countCustomers() {
        return (int) usersById.values().stream().filter(u -> !"ADMIN".equalsIgnoreCase(u.getRole())).count();
    }

    // ==========================================
    // CATEGORY OPERATIONS
    // ==========================================
    public List<Category> getAllCategories(boolean onlyActive) {
        return categoriesById.values().stream()
                .filter(c -> !onlyActive || c.isActive())
                .sorted(Comparator.comparingInt(Category::getDisplayOrder).thenComparing(Category::getName))
                .peek(c -> c.setItemCount((int) foodItemsById.values().stream().filter(f -> f.getCategoryId() == c.getId()).count()))
                .collect(Collectors.toList());
    }

    public Category getCategoryById(int id) {
        return categoriesById.get(id);
    }

    public synchronized boolean addCategory(Category c) {
        int id = categoryIdGen.incrementAndGet();
        c.setId(id);
        c.setCreatedAt(new Timestamp(System.currentTimeMillis()));
        if (c.getSlug() == null || c.getSlug().isEmpty()) {
            c.setSlug(c.getName().toLowerCase().replaceAll("[^a-z0-9]+", "-"));
        }
        categoriesById.put(id, c);
        return true;
    }

    public synchronized boolean updateCategory(Category c) {
        if (!categoriesById.containsKey(c.getId())) return false;
        Category existing = categoriesById.get(c.getId());
        existing.setName(c.getName());
        existing.setSlug(c.getSlug());
        existing.setDescription(c.getDescription());
        existing.setImageUrl(c.getImageUrl());
        existing.setDisplayOrder(c.getDisplayOrder());
        existing.setActive(c.isActive());
        return true;
    }

    public synchronized boolean deleteCategory(int id) {
        return categoriesById.remove(id) != null;
    }

    public int countCategories() {
        return categoriesById.size();
    }

    // ==========================================
    // FOOD ITEM OPERATIONS
    // ==========================================
    public List<FoodItem> getAllFoodItems(boolean onlyAvailable) {
        return foodItemsById.values().stream()
                .filter(f -> !onlyAvailable || f.isAvailable())
                .sorted(Comparator.comparingInt(FoodItem::getCategoryId).thenComparing(FoodItem::getName))
                .collect(Collectors.toList());
    }

    public List<FoodItem> getFoodItemsByCategory(int categoryId, boolean onlyAvailable) {
        return foodItemsById.values().stream()
                .filter(f -> f.getCategoryId() == categoryId && (!onlyAvailable || f.isAvailable()))
                .sorted(Comparator.comparing(FoodItem::isPopular).reversed().thenComparing(FoodItem::getName))
                .collect(Collectors.toList());
    }

    public FoodItem getFoodItemById(int id) {
        return foodItemsById.get(id);
    }

    public List<FoodItem> searchFoodItems(String query, int limit) {
        if (query == null || query.trim().isEmpty()) return Collections.emptyList();
        String q = query.trim().toLowerCase();
        return foodItemsById.values().stream()
                .filter(FoodItem::isAvailable)
                .filter(f -> f.getName().toLowerCase().contains(q) ||
                             (f.getDescription() != null && f.getDescription().toLowerCase().contains(q)) ||
                             (f.getCategoryName() != null && f.getCategoryName().toLowerCase().contains(q)))
                .sorted(Comparator.comparing((FoodItem f) -> f.getName().toLowerCase().startsWith(q) ? 0 : 1)
                        .thenComparing(FoodItem::getName))
                .limit(limit > 0 ? limit : 20)
                .collect(Collectors.toList());
    }

    public List<FoodItem> getPopularFoodItems(int limit) {
        return foodItemsById.values().stream()
                .filter(f -> f.isAvailable() && f.isPopular())
                .sorted(Comparator.comparingDouble(FoodItem::getRating).reversed())
                .limit(limit > 0 ? limit : 10)
                .collect(Collectors.toList());
    }

    public synchronized boolean addFoodItem(FoodItem item) {
        int id = foodIdGen.incrementAndGet();
        item.setId(id);
        item.setCreatedAt(new Timestamp(System.currentTimeMillis()));
        Category c = categoriesById.get(item.getCategoryId());
        if (c != null) item.setCategoryName(c.getName());
        foodItemsById.put(id, item);
        return true;
    }

    public synchronized boolean updateFoodItem(FoodItem item) {
        if (!foodItemsById.containsKey(item.getId())) return false;
        Category c = categoriesById.get(item.getCategoryId());
        if (c != null) item.setCategoryName(c.getName());
        item.setUpdatedAt(new Timestamp(System.currentTimeMillis()));
        foodItemsById.put(item.getId(), item);
        return true;
    }

    public synchronized boolean deleteFoodItem(int id) {
        return foodItemsById.remove(id) != null;
    }

    public synchronized boolean toggleFoodItemAvailability(int id, boolean available) {
        FoodItem item = foodItemsById.get(id);
        if (item != null) {
            item.setAvailable(available);
            return true;
        }
        return false;
    }

    public int countFoodItems() {
        return foodItemsById.size();
    }

    // ==========================================
    // ADDRESS OPERATIONS
    // ==========================================
    public List<Address> getAddressesByUserId(int userId) {
        return addressesById.values().stream()
                .filter(a -> a.getUserId() == userId)
                .sorted(Comparator.comparing(Address::isDefault).reversed().thenComparing(Address::getCreatedAt, Comparator.nullsLast(Comparator.reverseOrder())))
                .collect(Collectors.toList());
    }

    public Address getDefaultAddressByUserId(int userId) {
        return addressesById.values().stream()
                .filter(a -> a.getUserId() == userId && a.isDefault())
                .findFirst()
                .orElse(null);
    }

    public Address getAddressById(int id) {
        return addressesById.get(id);
    }

    public synchronized boolean addAddress(Address address) {
        if (address.isDefault()) {
            addressesById.values().stream()
                    .filter(a -> a.getUserId() == address.getUserId())
                    .forEach(a -> a.setDefault(false));
        }
        int id = addressIdGen.incrementAndGet();
        address.setId(id);
        address.setCreatedAt(new Timestamp(System.currentTimeMillis()));
        addressesById.put(id, address);
        return true;
    }

    public synchronized boolean setDefaultAddress(int addressId, int userId) {
        addressesById.values().stream()
                .filter(a -> a.getUserId() == userId)
                .forEach(a -> a.setDefault(a.getId() == addressId));
        return true;
    }

    // ==========================================
    // ORDER OPERATIONS
    // ==========================================
    public synchronized boolean createOrder(Order order, List<OrderItem> items) {
        int orderId = orderIdGen.incrementAndGet();
        order.setId(orderId);
        order.setCreatedAt(new Timestamp(System.currentTimeMillis()));

        List<OrderItem> savedItems = new ArrayList<>();
        for (OrderItem it : items) {
            it.setId(orderItemIdGen.incrementAndGet());
            it.setOrderId(orderId);
            savedItems.add(it);
        }
        order.setItems(savedItems);

        ordersById.put(orderId, order);
        ordersByNumber.put(order.getOrderNumber(), order);
        orderItemsByOrderId.put(orderId, new CopyOnWriteArrayList<>(savedItems));
        return true;
    }

    public Order getOrderByNumber(String orderNumber) {
        if (orderNumber == null) return null;
        Order order = ordersByNumber.get(orderNumber.trim());
        if (order != null) {
            order.setItems(orderItemsByOrderId.getOrDefault(order.getId(), Collections.emptyList()));
        }
        return order;
    }

    public Order getOrderById(int id) {
        Order order = ordersById.get(id);
        if (order != null) {
            order.setItems(orderItemsByOrderId.getOrDefault(id, Collections.emptyList()));
        }
        return order;
    }

    public List<Order> getOrdersByUserId(int userId) {
        return ordersById.values().stream()
                .filter(o -> o.getUserId() == userId)
                .sorted(Comparator.comparing(Order::getCreatedAt, Comparator.nullsLast(Comparator.reverseOrder())))
                .peek(o -> o.setItems(orderItemsByOrderId.getOrDefault(o.getId(), Collections.emptyList())))
                .collect(Collectors.toList());
    }

    public List<Order> getAllOrders(String statusFilter) {
        boolean hasFilter = statusFilter != null && !statusFilter.trim().isEmpty() && !"ALL".equalsIgnoreCase(statusFilter);
        return ordersById.values().stream()
                .filter(o -> !hasFilter || statusFilter.equalsIgnoreCase(o.getOrderStatus()))
                .sorted(Comparator.comparing(Order::getCreatedAt, Comparator.nullsLast(Comparator.reverseOrder())))
                .peek(o -> o.setItems(orderItemsByOrderId.getOrDefault(o.getId(), Collections.emptyList())))
                .collect(Collectors.toList());
    }

    public synchronized boolean updateOrderStatus(int orderId, String newStatus) {
        Order order = ordersById.get(orderId);
        if (order != null) {
            order.setOrderStatus(newStatus);
            order.setUpdatedAt(new Timestamp(System.currentTimeMillis()));
            return true;
        }
        return false;
    }

    public BigDecimal getTotalRevenue() {
        return ordersById.values().stream()
                .filter(o -> !Order.STATUS_CANCELLED.equalsIgnoreCase(o.getOrderStatus()))
                .map(Order::getTotalAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    public int countOrders() {
        return ordersById.size();
    }

    public List<OrderItem> getOrderItems(int orderId) {
        return orderItemsByOrderId.getOrDefault(orderId, Collections.emptyList());
    }
}
