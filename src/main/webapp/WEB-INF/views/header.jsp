<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${not empty pageTitle ? pageTitle : 'QuickBite - 10 Minute Grocery & Food Delivery'}</title>
    
    <!-- Meta SEO Tags -->
    <meta name="description" content="Order delicious food delivered to your door in 10 minutes with QuickBite. Fresh pizzas, burgers, biryanis, desserts and drinks.">
    <link rel="icon" type="image/svg+xml" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'><rect width='100' height='100' rx='20' fill='%23E23744'/><text y='70' x='50' font-size='56' text-anchor='middle' font-family='sans-serif' font-weight='bold' fill='%23FFFFFF'>Q</text></svg>">

    <!-- Bootstrap 5 CSS via CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- AOS Scroll Animations CSS via CDN -->
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
    
    <!-- QuickBite Red Theme CSS -->
    <link href="${pageContext.request.contextPath}/css/blinkit-theme.css" rel="stylesheet">
</head>
<body>

    <!-- STICKY QUICKBITE HEADER -->
    <header class="blinkit-header py-2">
        <div class="container-fluid px-lg-5">
            <div class="row align-items-center gy-2">
                
                <!-- Brand Logo & Delivery Tag -->
                <div class="col-auto d-flex align-items-center gap-3">
                    <a href="${pageContext.request.contextPath}/home" class="brand-logo-wrap">
                        <div class="brand-title">Quick<span>Bite</span></div>
                    </a>

                    <!-- Location Bar -->
                    <div class="location-selector d-none d-md-block" data-bs-toggle="modal" data-bs-target="#locationModal">
                        <div class="location-heading">
                            <span class="delivery-badge"><span class="pulse-dot"></span> 10 MINS</span>
                            <span>Delivery to</span>
                        </div>
                        <div class="location-address" id="headerLocationDisplay">
                            Indiranagar, Bengaluru, 560038
                        </div>
                    </div>
                </div>

                <!-- Center: Giant Live Search Box -->
                <div class="col">
                    <div class="search-wrapper">
                        <form id="mainSearchForm" action="${pageContext.request.contextPath}/search" method="GET" class="search-input-box">
                            <span class="search-icon-left">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                    <circle cx="11" cy="11" r="8"></circle>
                                    <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                                </svg>
                            </span>
                            <input type="text" id="mainSearchInput" name="q" class="search-input" 
                                   placeholder='Search "pizza", "burger", "biryani", "desserts"...' 
                                   value="${searchQuery}" autocomplete="off">
                            <button type="button" id="searchClearBtn" class="search-clear-btn" aria-label="Clear search">✕</button>
                        </form>

                        <!-- Live Search Suggestion Dropdown -->
                        <div id="searchSuggestionsDropdown" class="search-suggestions-dropdown"></div>
                    </div>
                </div>

                <!-- Right Actions: Account & Cart -->
                <div class="col-auto d-flex align-items-center gap-2">
                    
                    <!-- User Account Dropdown -->
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <div class="dropdown">
                                <button class="btn btn-nav-login dropdown-toggle d-flex align-items-center gap-2" 
                                        type="button" id="userMenuDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                                    <span class="badge bg-light text-dark rounded-circle p-2" style="border: 1px solid #E5E7EB;">
                                        👤
                                    </span>
                                    <span class="d-none d-lg-inline">${sessionScope.user.name}</span>
                                </button>
                                <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0 rounded-3 mt-2" aria-labelledby="userMenuDropdown">
                                    <li class="px-3 py-2 border-bottom">
                                        <div class="fw-bold">${sessionScope.user.name}</div>
                                        <div class="small text-muted">${sessionScope.user.email}</div>
                                    </li>
                                    <li>
                                        <a class="dropdown-item py-2" href="${pageContext.request.contextPath}/orders">
                                            📦 My Orders & Tracking
                                        </a>
                                    </li>
                                    <c:if test="${sessionScope.user.admin}">
                                        <li>
                                            <a class="dropdown-item py-2 text-primary fw-bold" href="${pageContext.request.contextPath}/admin/dashboard">
                                                ⚙️ Admin Dashboard
                                            </a>
                                        </li>
                                    </c:if>
                                    <li><hr class="dropdown-divider my-1"></li>
                                    <li>
                                        <a class="dropdown-item py-2 text-danger" href="${pageContext.request.contextPath}/logout">
                                            🚪 Logout
                                        </a>
                                    </li>
                                </ul>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/login" class="btn btn-nav-login">
                                Login
                            </a>
                        </c:otherwise>
                    </c:choose>

                    <!-- Blinkit Green Cart Button -->
                    <button type="button" id="headerCartBtn" class="btn-blinkit-cart trigger-cart-drawer" aria-label="Open Cart">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                            <circle cx="9" cy="21" r="1"></circle>
                            <circle cx="20" cy="21" r="1"></circle>
                            <path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"></path>
                        </svg>
                        <span class="d-none d-sm-inline">My Cart</span>
                    </button>

                </div>

            </div>
        </div>
    </header>

    <!-- Location Modal Mockup -->
    <div class="modal fade" id="locationModal" tabindex="-1" aria-labelledby="locationModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content rounded-4 border-0 shadow">
                <div class="modal-header border-0 pb-0">
                    <h5 class="modal-title fw-bold" id="locationModalLabel">Select Delivery Location</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p class="text-muted small mb-3">Instant 10-minute delivery is active in your neighbourhood.</p>
                    <div class="list-group">
                        <button type="button" class="list-group-item list-group-item-action d-flex align-items-center gap-3 py-3 rounded-3 mb-2 border" onclick="selectLocation('Indiranagar, Bengaluru, 560038')">
                            <span class="fs-4">🏠</span>
                            <div>
                                <div class="fw-bold">Home - Indiranagar</div>
                                <div class="small text-muted">100ft Road, Near Metro Station, Bengaluru</div>
                            </div>
                        </button>
                        <button type="button" class="list-group-item list-group-item-action d-flex align-items-center gap-3 py-3 rounded-3 mb-2 border" onclick="selectLocation('Bellandur, Outer Ring Road, 560103')">
                            <span class="fs-4">🏢</span>
                            <div>
                                <div class="fw-bold">Work - EcoSpace Tech Park</div>
                                <div class="small text-muted">Outer Ring Road, Bellandur, Bengaluru</div>
                            </div>
                        </button>
                        <button type="button" class="list-group-item list-group-item-action d-flex align-items-center gap-3 py-3 rounded-3 border" onclick="selectLocation('Koramangala 4th Block, Bengaluru, 560034')">
                            <span class="fs-4">📍</span>
                            <div>
                                <div class="fw-bold">Koramangala 4th Block</div>
                                <div class="small text-muted">Sony World Signal, Bengaluru</div>
                            </div>
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        function selectLocation(loc) {
            document.getElementById('headerLocationDisplay').textContent = loc;
            const modalEl = document.getElementById('locationModal');
            const modal = bootstrap.Modal.getInstance(modalEl);
            if (modal) modal.hide();
            if (window.showToast) showToast('Location Updated', 'Delivering to: ' + loc, 'success');
        }
    </script>
