<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="QuickBite - Food Delivery in 10 Minutes" scope="request"/>
<jsp:include page="/WEB-INF/views/header.jsp"/>

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
                    <form action="${pageContext.request.contextPath}/search" method="GET" class="hero-search-box">
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
                        <a href="${pageContext.request.contextPath}/search?cat=1" class="cuisine-pill">🍕 Pizza</a>
                        <a href="${pageContext.request.contextPath}/search?cat=2" class="cuisine-pill">🍔 Burgers</a>
                        <a href="${pageContext.request.contextPath}/search?cat=3" class="cuisine-pill">🍲 Biryani</a>
                        <a href="${pageContext.request.contextPath}/search?cat=4" class="cuisine-pill">🍟 Snacks</a>
                        <a href="${pageContext.request.contextPath}/search?cat=5" class="cuisine-pill">🍰 Desserts</a>
                        <a href="${pageContext.request.contextPath}/search?cat=6" class="cuisine-pill">🥤 Shakes</a>
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

    <!-- 2. CATEGORY CHIPS ROW -->
    <section class="mb-4" data-aos="fade-up" data-aos-delay="100">
        <div class="d-flex align-items-center justify-content-between mb-2">
            <h2 class="fs-5 fw-bold mb-0">Explore Categories</h2>
        </div>
        <div class="category-chips-wrapper">
            <c:forEach var="cat" items="${categories}">
                <a href="${pageContext.request.contextPath}/search?cat=${cat.id}" class="category-chip-card">
                    <img src="${cat.imageUrl}" alt="${cat.name}" class="category-chip-img" onerror="this.src='https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=100'">
                    <span class="category-chip-name">${cat.name}</span>
                </a>
            </c:forEach>
        </div>
    </section>

    <!-- 3. POPULAR & TRENDING CAROUSEL -->
    <c:if test="${not empty popularItems}">
        <section class="mb-5 carousel-container-wrap" data-aos="fade-up">
            <div class="d-flex align-items-center justify-content-between mb-3">
                <div>
                    <h2 class="fs-4 fw-bold mb-0">🔥 Trending Right Now</h2>
                    <span class="text-muted small">Top ordered dishes by foodies near you</span>
                </div>
                <div class="d-flex gap-2">
                    <button type="button" class="btn btn-sm btn-light border rounded-circle carousel-btn-left" aria-label="Previous">◀</button>
                    <button type="button" class="btn btn-sm btn-light border rounded-circle carousel-btn-right" aria-label="Next">▶</button>
                </div>
            </div>

            <div class="product-carousel-row">
                <c:forEach var="item" items="${popularItems}">
                    <div class="food-card">
                        <div class="food-card-img-wrap">
                            <!-- Veg / Non-Veg Icon -->
                            <div class="diet-icon ${item.veg ? 'veg' : 'non-veg'}"></div>
                            
                            <!-- Discount Badge -->
                            <c:if test="${item.hasDiscount()}">
                                <div class="discount-badge-corner">${item.getDiscountPercentage()}% OFF</div>
                            </c:if>

                            <!-- Image -->
                            <img src="${item.imageUrl}" alt="${item.name}" class="food-card-img" onerror="this.src='https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=300'">

                            <!-- Delivery Tag -->
                            <div class="delivery-badge-tag">
                                <span>⚡</span> ${item.deliveryTimeMins} MINS
                            </div>
                        </div>

                        <div>
                            <div class="food-name" title="${item.name}">${item.name}</div>
                            <div class="food-unit">${item.unit}</div>
                        </div>

                        <div class="food-card-bottom">
                            <div class="food-prices">
                                <div class="food-price-current">₹<fmt:formatNumber value="${item.effectivePrice}" maxFractionDigits="0"/></div>
                                <c:if test="${item.hasDiscount()}">
                                    <div class="food-price-mrp">₹<fmt:formatNumber value="${item.price}" maxFractionDigits="0"/></div>
                                </c:if>
                            </div>

                            <!-- The Iconic Blinkit Stepper Container -->
                            <div class="stepper-container" data-food-id="${item.id}">
                                <button type="button" class="btn-add-food" onclick="BlinkitCart.addItem(${item.id}, this)">
                                    ADD <span>+</span>
                                </button>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </section>
    </c:if>

    <!-- 4. HORIZONTAL PRODUCT CAROUSELS PER CATEGORY -->
    <c:forEach var="entry" items="${categoryItemsMap}">
        <c:set var="category" value="${entry.key}"/>
        <c:set var="items" value="${entry.value}"/>

        <section class="mb-5 carousel-container-wrap" data-aos="fade-up">
            <div class="d-flex align-items-center justify-content-between mb-3">
                <div>
                    <h2 class="fs-4 fw-bold mb-0">${category.name}</h2>
                    <span class="text-muted small">${category.description}</span>
                </div>
                <div class="d-flex align-items-center gap-2">
                    <a href="${pageContext.request.contextPath}/search?cat=${category.id}" class="text-danger fw-bold small text-decoration-none me-2">
                        See All →
                    </a>
                    <button type="button" class="btn btn-sm btn-light border rounded-circle carousel-btn-left" aria-label="Previous">◀</button>
                    <button type="button" class="btn btn-sm btn-light border rounded-circle carousel-btn-right" aria-label="Next">▶</button>
                </div>
            </div>

            <div class="product-carousel-row">
                <c:forEach var="item" items="${items}">
                    <div class="food-card">
                        <div class="food-card-img-wrap">
                            <div class="diet-icon ${item.veg ? 'veg' : 'non-veg'}"></div>
                            
                            <c:if test="${item.hasDiscount()}">
                                <div class="discount-badge-corner">${item.getDiscountPercentage()}% OFF</div>
                            </c:if>

                            <img src="${item.imageUrl}" alt="${item.name}" class="food-card-img" onerror="this.src='https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=300'">

                            <div class="delivery-badge-tag">
                                <span>⚡</span> ${item.deliveryTimeMins} MINS
                            </div>
                        </div>

                        <div>
                            <div class="food-name" title="${item.name}">${item.name}</div>
                            <div class="food-unit">${item.unit}</div>
                        </div>

                        <div class="food-card-bottom">
                            <div class="food-prices">
                                <div class="food-price-current">₹<fmt:formatNumber value="${item.effectivePrice}" maxFractionDigits="0"/></div>
                                <c:if test="${item.hasDiscount()}">
                                    <div class="food-price-mrp">₹<fmt:formatNumber value="${item.price}" maxFractionDigits="0"/></div>
                                </c:if>
                            </div>

                            <div class="stepper-container" data-food-id="${item.id}">
                                <button type="button" class="btn-add-food" onclick="BlinkitCart.addItem(${item.id}, this)">
                                    ADD <span>+</span>
                                </button>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </section>
    </c:forEach>

</main>

<jsp:include page="/WEB-INF/views/footer.jsp"/>
