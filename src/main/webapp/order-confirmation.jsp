<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Order Confirmed - QuickBite" scope="request"/>
<jsp:include page="/WEB-INF/views/header.jsp"/>

<main class="container my-5">
    <div class="row justify-content-center">
        <div class="col-lg-7">
            
            <!-- Celebration Banner -->
            <div class="card border-0 shadow-sm rounded-4 p-4 p-md-5 bg-white text-center mb-4" data-aos="zoom-in">
                <div class="mb-3">
                    <span class="d-inline-flex align-items-center justify-content-center rounded-circle bg-danger-subtle text-danger p-3 fs-1 shadow-sm" style="width: 80px; height: 80px;">
                        ✓
                    </span>
                </div>
                
                <h1 class="fs-2 fw-bold text-dark mb-1">Order Placed Successfully!</h1>
                <p class="text-muted mb-3">Your order <strong>#${order.orderNumber}</strong> has been received by our kitchen.</p>
                
                <div class="d-inline-flex align-items-center gap-2 bg-light px-3 py-2 rounded-pill mx-auto mb-4 border">
                    <span class="pulse-dot"></span>
                    <span class="fw-bold text-dark small">Estimated Delivery: <strong>${order.estimatedDeliveryMins} Minutes</strong></span>
                </div>

                <!-- Visual 4-Step Progress Tracker -->
                <div class="order-tracker-card text-start mt-2">
                    <div class="d-flex justify-content-between align-items-center mb-2">
                        <span class="fw-bold fs-6">Live Order Tracking</span>
                        <span class="badge ${order.statusBadgeClass} px-3 py-2">${order.statusLabel}</span>
                    </div>

                    <div class="timeline-track">
                        <div class="timeline-progress-bar" style="width: ${(order.statusStep - 1) * 33.33}%;"></div>

                        <!-- Step 1 -->
                        <div class="timeline-step ${order.statusStep >= 1 ? 'completed' : ''}">
                            <div class="step-node">📝</div>
                            <div class="step-title">Placed</div>
                        </div>

                        <!-- Step 2 -->
                        <div class="timeline-step ${order.statusStep >= 2 ? 'completed' : ''}">
                            <div class="step-node">🍳</div>
                            <div class="step-title">Preparing</div>
                        </div>

                        <!-- Step 3 -->
                        <div class="timeline-step ${order.statusStep >= 3 ? 'completed' : ''}">
                            <div class="step-node">🛵</div>
                            <div class="step-title">On The Way</div>
                        </div>

                        <!-- Step 4 -->
                        <div class="timeline-step ${order.statusStep >= 4 ? 'completed' : ''}">
                            <div class="step-node">🏠</div>
                            <div class="step-title">Delivered</div>
                        </div>
                    </div>
                </div>

                <!-- Order Details Card -->
                <div class="bg-light rounded-4 p-4 text-start mb-4 border">
                    <div class="row g-3">
                        <div class="col-sm-6">
                            <span class="text-muted small">Delivery Address</span>
                            <div class="fw-bold text-dark small">${order.deliveryAddressText}</div>
                        </div>
                        <div class="col-sm-6">
                            <span class="text-muted small">Payment Details</span>
                            <div class="fw-bold text-dark small">
                                ${order.paymentMethod} • <span class="badge bg-success-subtle text-success">${order.paymentStatus}</span>
                            </div>
                        </div>
                    </div>

                    <hr class="my-3">

                    <span class="text-muted small mb-2 d-block">Items Ordered</span>
                    <c:forEach var="item" items="${order.items}">
                        <div class="d-flex justify-content-between align-items-center py-1 small">
                            <span>${item.itemName} <span class="text-muted">× ${item.quantity}</span></span>
                            <span class="fw-bold">₹<fmt:formatNumber value="${item.totalPrice}" maxFractionDigits="2"/></span>
                        </div>
                    </c:forEach>

                    <hr class="my-3">

                    <div class="d-flex justify-content-between fw-bold text-dark">
                        <span>Total Paid</span>
                        <span class="text-danger fs-5">₹<fmt:formatNumber value="${order.totalAmount}" maxFractionDigits="2"/></span>
                    </div>
                </div>

                <div class="d-flex flex-wrap gap-2 justify-content-center">
                    <a href="${pageContext.request.contextPath}/orders" class="btn btn-outline-danger rounded-pill px-4 fw-bold">
                        View All Orders
                    </a>
                    <a href="${pageContext.request.contextPath}/home" class="btn btn-danger rounded-pill px-4 fw-bold" style="background-color: var(--theme-red); border-color: var(--theme-red);">
                        Order More Food
                    </a>
                </div>

            </div>

        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/views/footer.jsp"/>
