<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Search Food - QuickBite" scope="request"/>
<jsp:include page="/WEB-INF/views/header.jsp"/>

<main class="container-fluid px-lg-5 my-4">

    <!-- Breadcrumb & Search Summary -->
    <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-4">
        <div>
            <h1 class="fs-3 fw-bold mb-1">
                <c:choose>
                    <c:when test="${not empty selectedCategory}">
                        ${selectedCategory.name}
                    </c:when>
                    <c:when test="${not empty searchQuery}">
                        Results for "<span class="text-danger">${searchQuery}</span>"
                    </c:when>
                    <c:otherwise>
                        All Food Items
                    </c:otherwise>
                </c:choose>
            </h1>
            <span class="text-muted small">${items.size()} items available for instant 10-minute delivery</span>
        </div>

        <!-- Filter Chips -->
        <div class="d-flex align-items-center gap-2 flex-wrap">
            <button type="button" class="btn btn-sm btn-outline-secondary rounded-pill px-3 filter-diet-btn active" data-filter="all">
                All Items
            </button>
            <button type="button" class="btn btn-sm btn-outline-success rounded-pill px-3 filter-diet-btn" data-filter="veg">
                🟢 Veg Only
            </button>
            <button type="button" class="btn btn-sm btn-outline-danger rounded-pill px-3 filter-diet-btn" data-filter="non-veg">
                🔴 Non-Veg
            </button>
        </div>
    </div>

    <!-- Category Quick Filter Row -->
    <div class="category-chips-wrapper mb-4">
        <a href="${pageContext.request.contextPath}/search" class="category-chip-card ${empty selectedCategory && empty searchQuery ? 'active' : ''}">
            <div class="category-chip-img d-flex align-items-center justify-content-center fs-4">🍽️</div>
            <span class="category-chip-name">All Items</span>
        </a>
        <c:forEach var="cat" items="${categories}">
            <a href="${pageContext.request.contextPath}/search?cat=${cat.id}" class="category-chip-card ${selectedCategory.id == cat.id ? 'active' : ''}">
                <img src="${cat.imageUrl}" alt="${cat.name}" class="category-chip-img" onerror="this.src='https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=100'">
                <span class="category-chip-name">${cat.name}</span>
            </a>
        </c:forEach>
    </div>

    <!-- Product Grid -->
    <c:choose>
        <c:when test="${not empty items}">
            <div class="row row-cols-2 row-cols-sm-3 row-cols-md-4 row-cols-lg-5 row-cols-xl-6 g-3" id="productGrid">
                <c:forEach var="item" items="${items}">
                    <div class="col product-grid-col" data-is-veg="${item.veg ? 'true' : 'false'}">
                        <div class="food-card w-100" style="min-height: 290px;">
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
                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <div class="text-center py-5 bg-white rounded-4 border">
                <div class="fs-1 mb-3">🔍</div>
                <h3 class="fw-bold">No food items found</h3>
                <p class="text-muted">We couldn't find anything matching your search. Try checking your spelling or search for popular items.</p>
                <a href="${pageContext.request.contextPath}/home" class="btn btn-danger rounded-pill px-4 fw-bold" style="background-color: var(--theme-red); border-color: var(--theme-red);">
                    Back to Home
                </a>
            </div>
        </c:otherwise>
    </c:choose>

</main>

<script>
    // Client side dietary filter
    document.querySelectorAll('.filter-diet-btn').forEach(btn => {
        btn.addEventListener('click', () => {
            document.querySelectorAll('.filter-diet-btn').forEach(b => b.classList.remove('active', 'btn-success', 'btn-danger', 'btn-secondary'));
            btn.classList.add('active');

            const filter = btn.getAttribute('data-filter');
            const cols = document.querySelectorAll('.product-grid-col');

            cols.forEach(col => {
                const isVeg = col.getAttribute('data-is-veg') === 'true';
                if (filter === 'all') {
                    col.style.display = 'block';
                } else if (filter === 'veg') {
                    col.style.display = isVeg ? 'block' : 'none';
                } else if (filter === 'non-veg') {
                    col.style.display = !isVeg ? 'block' : 'none';
                }
            });
        });
    });
</script>

<jsp:include page="/WEB-INF/views/footer.jsp"/>
