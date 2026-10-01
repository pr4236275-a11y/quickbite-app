<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="QuickBite - Food Delivery in 10 Minutes" scope="request"/>
<jsp:include page="/WEB-INF/views/header.jsp"/>

<main class="container-fluid px-lg-5">
    
    <!-- 1. HERO BANNER SECTION -->
    <section class="hero-banner-section mb-4" data-aos="fade-up">
        <div class="row align-items-center">
            <div class="col-lg-7">
                <span class="hero-pill-tag">⚡ India's Fastest Delivery</span>
                <h1 class="hero-heading">
                    Craving delicious food? <br>
                    Delivered in <span>10 minutes</span>.
                </h1>
                <p class="hero-subtitle">
                    Cheesy pizzas, juicy burgers, royal dum biryani and fresh sweet treats delivered hot & fresh from hyper-local kitchens.
                </p>
                <div class="hero-feature-badges">
                    <div class="feature-badge-item">
                        <span>🚀</span> Free delivery above ₹199
                    </div>
                    <div class="feature-badge-item">
                        <span>🔥</span> Hot & Fresh Guarantee
                    </div>
                    <div class="feature-badge-item">
                        <span>🛡️</span> 100% Hygienic Packaging
                    </div>
                </div>
            </div>
            <div class="col-lg-5 d-none d-lg-block text-center hero-image-wrap">
                <img src="https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=600&auto=format&fit=crop&q=80" 
                     alt="Delicious Food" class="rounded-4 img-fluid shadow-lg" style="max-height: 280px; object-fit: cover; width: 100%;">
            </div>
        </div>
    </section>

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
