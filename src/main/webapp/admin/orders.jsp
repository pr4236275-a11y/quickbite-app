<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Manage Orders - Blinkit Admin" scope="request"/>
<jsp:include page="/WEB-INF/views/header.jsp"/>

<main class="container-fluid px-lg-5 my-4">

    <!-- Header Actions -->
    <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-4 pb-3 border-bottom">
        <div>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-1 small">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
                    <li class="breadcrumb-item active" aria-current="page">Orders</li>
                </ol>
            </nav>
            <h1 class="fs-3 fw-bold mb-0">Customer Orders &amp; Kitchen Dispatch (${orders.size()})</h1>
        </div>
        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-outline-secondary rounded-pill btn-sm px-3">
                Refresh
            </a>
        </div>
    </div>

    <!-- Status Filter Tabs -->
    <div class="d-flex gap-2 overflow-auto pb-3 mb-3">
        <a href="${pageContext.request.contextPath}/admin/orders?status=ALL" class="btn btn-sm ${selectedStatus == 'ALL' ? 'btn-dark' : 'btn-outline-secondary'} rounded-pill px-3">
            All Orders
        </a>
        <a href="${pageContext.request.contextPath}/admin/orders?status=PLACED" class="btn btn-sm ${selectedStatus == 'PLACED' ? 'btn-primary' : 'btn-outline-primary'} rounded-pill px-3">
            Placed
        </a>
        <a href="${pageContext.request.contextPath}/admin/orders?status=PREPARING" class="btn btn-sm ${selectedStatus == 'PREPARING' ? 'btn-warning text-dark' : 'btn-outline-warning text-dark'} rounded-pill px-3">
            Preparing
        </a>
        <a href="${pageContext.request.contextPath}/admin/orders?status=OUT_FOR_DELIVERY" class="btn btn-sm ${selectedStatus == 'OUT_FOR_DELIVERY' ? 'btn-info text-dark' : 'btn-outline-info text-dark'} rounded-pill px-3">
            Out for Delivery
        </a>
        <a href="${pageContext.request.contextPath}/admin/orders?status=DELIVERED" class="btn btn-sm ${selectedStatus == 'DELIVERED' ? 'btn-success' : 'btn-outline-success'} rounded-pill px-3">
            Delivered
        </a>
        <a href="${pageContext.request.contextPath}/admin/orders?status=CANCELLED" class="btn btn-sm ${selectedStatus == 'CANCELLED' ? 'btn-danger' : 'btn-outline-danger'} rounded-pill px-3">
            Cancelled
        </a>
    </div>

    <!-- Orders Table -->
    <div class="card border-0 shadow-sm rounded-4 bg-white overflow-hidden">
        <div class="table-responsive">
            <table class="table align-middle table-hover mb-0">
                <thead class="table-light">
                    <tr class="small text-muted">
                        <th>Order Details</th>
                        <th>Customer &amp; Address</th>
                        <th>Items Ordered</th>
                        <th>Amount &amp; Pay</th>
                        <th>Dispatch Status</th>
                        <th class="text-end">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="order" items="${orders}">
                        <tr>
                            <td>
                                <div class="fw-bold text-dark">#${order.orderNumber}</div>
                                <div class="text-muted small">${order.formattedDate}</div>
                                <div class="small text-success mt-1">⚡ ${order.estimatedDeliveryMins} Mins ETA</div>
                            </td>
                            <td style="max-width: 250px;">
                                <div class="fw-bold small text-dark">${order.customerName}</div>
                                <div class="text-muted small">${order.customerPhone}</div>
                                <div class="small text-muted text-truncate" title="${order.deliveryAddressText}">
                                    📍 ${order.deliveryAddressText}
                                </div>
                            </td>
                            <td style="max-width: 220px;">
                                <div class="small">
                                    <c:forEach var="item" items="${order.items}">
                                        <div class="text-truncate" title="${item.itemName}">
                                            • ${item.itemName} <span class="text-muted">× ${item.quantity}</span>
                                        </div>
                                    </c:forEach>
                                </div>
                            </td>
                            <td>
                                <div class="fw-bold text-success fs-6">₹<fmt:formatNumber value="${order.totalAmount}" maxFractionDigits="2"/></div>
                                <div class="small text-muted">
                                    <span class="badge bg-light text-dark border">${order.paymentMethod}</span>
                                    <span class="badge bg-success-subtle text-success">${order.paymentStatus}</span>
                                </div>
                            </td>
                            <td>
                                <form action="${pageContext.request.contextPath}/admin/orders" method="POST" class="d-flex align-items-center gap-2">
                                    <input type="hidden" name="action" value="updateStatus">
                                    <input type="hidden" name="orderId" value="${order.id}">
                                    <select name="newStatus" class="form-select form-select-sm rounded-3 fw-bold" onchange="this.form.submit()">
                                        <option value="PLACED" ${order.orderStatus == 'PLACED' ? 'selected' : ''}>PLACED</option>
                                        <option value="PREPARING" ${order.orderStatus == 'PREPARING' ? 'selected' : ''}>PREPARING</option>
                                        <option value="OUT_FOR_DELIVERY" ${order.orderStatus == 'OUT_FOR_DELIVERY' ? 'selected' : ''}>OUT_FOR_DELIVERY</option>
                                        <option value="DELIVERED" ${order.orderStatus == 'DELIVERED' ? 'selected' : ''}>DELIVERED</option>
                                        <option value="CANCELLED" ${order.orderStatus == 'CANCELLED' ? 'selected' : ''}>CANCELLED</option>
                                    </select>
                                </form>
                            </td>
                            <td class="text-end">
                                <a href="${pageContext.request.contextPath}/order-confirmation?orderNumber=${order.orderNumber}" class="btn btn-sm btn-outline-secondary rounded-pill px-3">
                                    Receipt
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
