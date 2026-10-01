<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

    <!-- Include Cart Drawer -->
    <jsp:include page="/WEB-INF/views/cart-drawer.jsp" />

    <!-- FOOTER -->
    <footer class="bg-white border-top mt-5 pt-5 pb-4">
        <div class="container-fluid px-lg-5">
            <div class="row g-4 mb-4">
                
                <div class="col-lg-4 col-md-6">
                    <div class="brand-title mb-2">quick<span>bite</span></div>
                    <p class="text-muted small mb-3">
                        Fresh food and snacks delivered to your door in 10 minutes with Quickbite. Cheesy pizzas, juicy burgers, royal biryani, and thick shakes.
                    </p>
                    <div class="d-flex align-items-center gap-3">
                        <span class="badge bg-light text-dark p-2 border">⚡ 10 Min Delivery</span>
                        <span class="badge bg-light text-dark p-2 border">🛡️ Safe & Hygienic</span>
                        <span class="badge bg-light text-dark p-2 border">💳 Instant UPI / COD</span>
                    </div>
                </div>

                <div class="col-lg-2 col-md-3 col-6">
                    <h6 class="fw-bold mb-3">Categories</h6>
                    <ul class="list-unstyled small text-muted d-flex flex-column gap-2">
                        <li><a href="${pageContext.request.contextPath}/search?cat=1" class="text-decoration-none text-muted">🍕 Pizza</a></li>
                        <li><a href="${pageContext.request.contextPath}/search?cat=2" class="text-decoration-none text-muted">🍔 Burgers & Wraps</a></li>
                        <li><a href="${pageContext.request.contextPath}/search?cat=3" class="text-decoration-none text-muted">🍚 Biryani Bowls</a></li>
                        <li><a href="${pageContext.request.contextPath}/search?cat=4" class="text-decoration-none text-muted">🍟 Quick Fries</a></li>
                        <li><a href="${pageContext.request.contextPath}/search?cat=5" class="text-decoration-none text-muted">🍨 Desserts & Shakes</a></li>
                    </ul>
                </div>

                <div class="col-lg-2 col-md-3 col-6">
                    <h6 class="fw-bold mb-3">Customer Support</h6>
                    <ul class="list-unstyled small text-muted d-flex flex-column gap-2">
                        <li><a href="${pageContext.request.contextPath}/orders" class="text-decoration-none text-muted">My Orders</a></li>
                        <li><a href="#" class="text-decoration-none text-muted">Delivery FAQs</a></li>
                        <li><a href="#" class="text-decoration-none text-muted">Terms of Service</a></li>
                        <li><a href="#" class="text-decoration-none text-muted">Privacy Policy</a></li>
                        <li><a href="#" class="text-decoration-none text-muted">Security & Safety</a></li>
                    </ul>
                </div>

                <div class="col-lg-4 col-md-6">
                    <h6 class="fw-bold mb-3">Delivery Partner Safety</h6>
                    <div class="p-3 bg-light rounded-3 small text-muted border">
                        <div class="fw-bold text-dark mb-1">⚡ Superfast 10-minute Delivery</div>
                        Our delivery partners ride within speed limits thanks to strategically located micro-warehouses and cloud kitchens within 2 km of your location.
                    </div>
                </div>

            </div>

            <hr class="my-4">

            <div class="d-flex flex-wrap align-items-center justify-content-between small text-muted gap-2">
                <div>© <%= java.time.Year.now().getValue() %> QuickBite (Food Ordering System). All rights reserved. Built with Jakarta Servlets, JSP &amp; In-Memory DB.</div>
                <div class="d-flex gap-3">
                    <span>UPI Accepted</span>
                    <span>•</span>
                    <span>Cash on Delivery</span>
                    <span>•</span>
                    <span>Net Banking</span>
                </div>
            </div>
        </div>
    </footer>

    <!-- Bootstrap 5 JS Bundle CDN -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <!-- AOS JS CDN -->
    <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>

    <!-- GSAP CDN -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.5/gsap.min.js"></script>

    <!-- Application JavaScripts -->
    <script src="${pageContext.request.contextPath}/js/toast.js"></script>
    <script src="${pageContext.request.contextPath}/js/cart.js"></script>
    <script src="${pageContext.request.contextPath}/js/search.js"></script>
    <script src="${pageContext.request.contextPath}/js/animations.js"></script>

    <!-- Global App Bootstrapper -->
    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const ctx = '${pageContext.request.contextPath}';
            BlinkitCart.init(ctx);
            BlinkitSearch.init(ctx);

            // Trigger Toasts from Request / Session Parameters if present
            <c:if test="${not empty param.success}">
                showToast('Success', '<c:out value="${param.success}"/>', 'success');
            </c:if>
            <c:if test="${not empty param.error}">
                showToast('Notice', '<c:out value="${param.error}"/>', 'error');
            </c:if>
            <c:if test="${not empty param.info}">
                showToast('Info', '<c:out value="${param.info}"/>', 'info');
            </c:if>
        });
    </script>
</body>
</html>
