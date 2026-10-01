<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="My Orders - QuickBite" scope="request"/>
<jsp:include page="/WEB-INF/views/header.jsp"/>

<main class="container my-4">
    
    <div class="d-flex align-items-center justify-content-between mb-4">
        <div>
            <h1 class="fs-3 fw-bold mb-1">My Orders &amp; Deliveries</h1>
            <span class="text-muted small">Track current orders and view past receipts</span>
        </div>
        <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-danger rounded-pill px-4 fw-bold btn-sm">
            + Order More
        </a>
    </div>

    <c:choose>
        <c:when test="${not empty orders}">
            <div class="row g-4">
                <c:forEach var="order" items="${orders}">
                    <div class="col-12" data-aos="fade-up">
                        <div class="card border-0 shadow-sm rounded-4 p-4 bg-white">
                            
                            <!-- Card Header -->
                            <div class="d-flex flex-wrap align-items-center justify-content-between gap-2 pb-3 border-bottom">
                                <div>
                                    <div class="fw-bold fs-6 text-dark">Order #${order.orderNumber}</div>
                                    <div class="text-muted small">Placed on ${order.formattedDate}</div>
                                </div>
                                <div class="d-flex align-items-center gap-2">
                                    <span class="badge ${order.statusBadgeClass} px-3 py-2 fs-7">${order.statusLabel}</span>
                                    <span class="badge bg-light text-dark border px-3 py-2">${order.paymentMethod}</span>
                                </div>
                            </div>

                            <!-- Live Progress Timeline -->
                            <div class="order-tracker-card border-0 p-0 my-3 shadow-none">
                                <div class="timeline-track">
                                    <div class="timeline-progress-bar" style="width: ${(order.statusStep - 1) * 33.33}%;"></div>

                                    <div class="timeline-step ${order.statusStep >= 1 ? 'completed' : ''}">
                                        <div class="step-node">📝</div>
                                        <div class="step-title">Placed</div>
                                    </div>
                                    <div class="timeline-step ${order.statusStep >= 2 ? 'completed' : ''}">
                                        <div class="step-node">🍳</div>
                                        <div class="step-title">Preparing</div>
                                    </div>
                                    <div class="timeline-step ${order.statusStep >= 3 ? 'completed' : ''}">
                                        <div class="step-node">🛵</div>
                                        <div class="step-title">On The Way</div>
                                    </div>
                                    <div class="timeline-step ${order.statusStep >= 4 ? 'completed' : ''}">
                                        <div class="step-node">🏠</div>
                                        <div class="step-title">Delivered</div>
                                    </div>
                                </div>
                            </div>

                            <!-- Items List -->
                            <div class="bg-light rounded-3 p-3 mb-3">
                                <div class="row g-2">
                                    <c:forEach var="item" items="${order.items}">
                                        <div class="col-md-6 d-flex align-items-center justify-content-between py-1 border-bottom">
                                            <span class="small fw-semibold text-dark">
                                                ${item.itemName} <span class="text-muted">× ${item.quantity}</span>
                                            </span>
                                            <span class="small fw-bold">₹<fmt:formatNumber value="${item.totalPrice}" maxFractionDigits="2"/></span>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>

                            <!-- Card Footer -->
                            <div class="d-flex flex-wrap align-items-center justify-content-between pt-2 gap-2">
                                <div class="small text-muted">
                                    Delivery to: <strong>${order.deliveryAddressText}</strong>
                                </div>
                                <div class="d-flex align-items-center gap-3">
                                    <div class="fs-5 fw-bold text-dark">
                                        Total: <span class="text-danger">₹<fmt:formatNumber value="${order.totalAmount}" maxFractionDigits="2"/></span>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/order-confirmation?orderNumber=${order.orderNumber}" class="btn btn-sm btn-outline-secondary rounded-pill px-3">
                                        View Receipt
                                    </a>
                                </div>
                            </div>

                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <div class="text-center py-5 bg-white rounded-4 border">
                <div class="fs-1 mb-3">📦</div>
                <h3 class="fw-bold">No orders placed yet</h3>
                <p class="text-muted">Craving your favorite snacks or meals? Order now and receive it in 10 minutes.</p>
                <a href="${pageContext.request.contextPath}/home" class="btn btn-danger rounded-pill px-4 fw-bold" style="background-color: var(--theme-red); border-color: var(--theme-red);">
                    Start Ordering
                </a>
            </div>
        </c:otherwise>
    </c:choose>

</main>

<jsp:include page="/WEB-INF/views/footer.jsp"/>
