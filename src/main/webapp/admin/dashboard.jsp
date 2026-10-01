<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Admin Dashboard - QuickBite" scope="request"/>
<jsp:include page="/WEB-INF/views/header.jsp"/>

<main class="container my-4">

    <!-- Admin Nav Tabs -->
    <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-4 pb-3 border-bottom">
        <div>
            <span class="badge bg-warning text-dark px-3 py-1 rounded-pill fw-bold">Admin Portal</span>
            <h1 class="fs-3 fw-bold mb-0 mt-1">Store Performance &amp; Operations</h1>
        </div>
        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/admin/items/new" class="btn btn-danger rounded-pill fw-bold btn-sm px-3" style="background-color: var(--theme-red); border-color: var(--theme-red);">
                + Add Food Item
            </a>
            <a href="${pageContext.request.contextPath}/admin/categories" class="btn btn-outline-secondary rounded-pill fw-bold btn-sm px-3">
                Categories
            </a>
            <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-outline-primary rounded-pill fw-bold btn-sm px-3">
                Manage Orders
            </a>
        </div>
    </div>

    <!-- 4 High Impact Metric Cards -->
    <div class="row g-3 mb-4">
        
        <div class="col-sm-6 col-lg-3">
            <div class="admin-card-stat">
                <div class="stat-icon-wrap bg-success-subtle text-success">💰</div>
                <div>
                    <div class="stat-value">₹<fmt:formatNumber value="${totalRevenue}" maxFractionDigits="0"/></div>
                    <div class="stat-label">Total Revenue</div>
                </div>
            </div>
        </div>

        <div class="col-sm-6 col-lg-3">
            <div class="admin-card-stat">
                <div class="stat-icon-wrap bg-primary-subtle text-primary">📦</div>
                <div>
                    <div class="stat-value">${totalOrders}</div>
                    <div class="stat-label">Total Orders</div>
                </div>
            </div>
        </div>

        <div class="col-sm-6 col-lg-3">
            <div class="admin-card-stat">
                <div class="stat-icon-wrap bg-warning-subtle text-warning">🍕</div>
                <div>
                    <div class="stat-value">${totalItems}</div>
                    <div class="stat-label">Menu Items</div>
                </div>
            </div>
        </div>

        <div class="col-sm-6 col-lg-3">
            <div class="admin-card-stat">
                <div class="stat-icon-wrap bg-info-subtle text-info">👥</div>
                <div>
                    <div class="stat-value">${totalCustomers}</div>
                    <div class="stat-label">Active Customers</div>
                </div>
            </div>
        </div>

    </div>

    <!-- Quick Navigation Hub -->
    <div class="row g-3 mb-4">
        <div class="col-md-4">
            <div class="card border-0 shadow-sm rounded-4 p-3 bg-white h-100">
                <h5 class="fw-bold mb-2">🍔 Food Catalog</h5>
                <p class="text-muted small mb-3">Add, edit pricing, update discounts, or toggle instant availability of food items.</p>
                <div class="mt-auto">
                    <a href="${pageContext.request.contextPath}/admin/items" class="btn btn-sm btn-outline-success rounded-pill px-3">
                        View All Items →
                    </a>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card border-0 shadow-sm rounded-4 p-3 bg-white h-100">
                <h5 class="fw-bold mb-2">📂 Categories</h5>
                <p class="text-muted small mb-3">Manage categories, icons, slugs, and control display orders on the home page.</p>
                <div class="mt-auto">
                    <a href="${pageContext.request.contextPath}/admin/categories" class="btn btn-sm btn-outline-secondary rounded-pill px-3">
                        Manage Categories →
                    </a>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card border-0 shadow-sm rounded-4 p-3 bg-white h-100">
                <h5 class="fw-bold mb-2">🛵 Live Orders Dispatch</h5>
                <p class="text-muted small mb-3">Monitor incoming orders, transition statuses from Preparing to Out for Delivery.</p>
                <div class="mt-auto">
                    <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-sm btn-outline-primary rounded-pill px-3">
                        Dispatch Orders →
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- Recent Orders Table -->
    <div class="card border-0 shadow-sm rounded-4 p-4 bg-white">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h2 class="fs-5 fw-bold mb-0">Recent Orders</h2>
            <a href="${pageContext.request.contextPath}/admin/orders" class="text-danger fw-bold small text-decoration-none">
                View All Orders (${totalOrders}) →
            </a>
        </div>

        <div class="table-responsive">
            <table class="table align-middle table-hover">
                <thead class="table-light">
                    <tr class="small text-muted">
                        <th>Order #</th>
                        <th>Customer</th>
                        <th>Amount</th>
                        <th>Payment</th>
                        <th>Order Status</th>
                        <th>Time</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="order" items="${recentOrders}">
                        <tr>
                            <td class="fw-bold text-dark">#${order.orderNumber}</td>
                            <td>
                                <div class="fw-bold small">${order.customerName}</div>
                                <div class="text-muted" style="font-size: 11px;">${order.customerPhone}</div>
                            </td>
                            <td class="fw-bold text-success">₹<fmt:formatNumber value="${order.totalAmount}" maxFractionDigits="2"/></td>
                            <td>
                                <span class="badge bg-light text-dark border">${order.paymentMethod}</span>
                            </td>
                            <td>
                                <span class="badge ${order.statusBadgeClass} px-2 py-1">${order.statusLabel}</span>
                            </td>
                            <td class="small text-muted">${order.formattedDate}</td>
                            <td>
                                <a href="${pageContext.request.contextPath}/order-confirmation?orderNumber=${order.orderNumber}" class="btn btn-sm btn-light border rounded-pill">
                                    Details
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

</main>

<jsp:include page="/WEB-INF/views/footer.jsp"/>
