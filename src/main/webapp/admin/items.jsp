<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Manage Food Items - QuickBite Admin" scope="request"/>
<jsp:include page="/WEB-INF/views/header.jsp"/>

<main class="container-fluid px-lg-5 my-4">

    <!-- Header Actions -->
    <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-4 pb-3 border-bottom">
        <div>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-1 small">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
                    <li class="breadcrumb-item active" aria-current="page">Food Items</li>
                </ol>
            </nav>
            <h1 class="fs-3 fw-bold mb-0">Food Items Catalog (${items.size()})</h1>
        </div>
        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/admin/items/new" class="btn btn-danger rounded-pill fw-bold" style="background-color: var(--theme-red); border-color: var(--theme-red);">
                + Add Food Item
            </a>
        </div>
    </div>

    <!-- Category Filter Bar -->
    <div class="d-flex gap-2 overflow-auto pb-3 mb-3">
        <a href="${pageContext.request.contextPath}/admin/items" class="btn btn-sm ${selectedCategory == 'ALL' ? 'btn-dark' : 'btn-outline-secondary'} rounded-pill px-3">
            All Items
        </a>
        <c:forEach var="cat" items="${categories}">
            <a href="${pageContext.request.contextPath}/admin/items?cat=${cat.id}" class="btn btn-sm ${selectedCategory == cat.id ? 'btn-dark' : 'btn-outline-secondary'} rounded-pill px-3">
                ${cat.name}
            </a>
        </c:forEach>
    </div>

    <!-- Items Table -->
    <div class="card border-0 shadow-sm rounded-4 bg-white overflow-hidden">
        <div class="table-responsive">
            <table class="table align-middle table-hover mb-0">
                <thead class="table-light">
                    <tr class="small text-muted">
                        <th>Image</th>
                        <th>Item Details</th>
                        <th>Category</th>
                        <th>Diet</th>
                        <th>Price</th>
                        <th>Discounted</th>
                        <th>Available</th>
                        <th class="text-end">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="item" items="${items}">
                        <tr>
                            <td style="width: 70px;">
                                <img src="${item.imageUrl}" alt="${item.name}" class="rounded-3" style="width: 54px; height: 54px; object-fit: cover;" onerror="this.src='https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=100'">
                            </td>
                            <td>
                                <div class="fw-bold text-dark">${item.name}</div>
                                <div class="text-muted small">${item.unit} • ⚡ ${item.deliveryTimeMins} mins</div>
                            </td>
                            <td>
                                <span class="badge bg-light text-dark border">${item.categoryName}</span>
                            </td>
                            <td>
                                <span class="badge ${item.veg ? 'bg-success-subtle text-success' : 'bg-danger-subtle text-danger'}">
                                    ${item.veg ? 'Veg' : 'Non-Veg'}
                                </span>
                            </td>
                            <td class="text-muted">₹<fmt:formatNumber value="${item.price}" maxFractionDigits="2"/></td>
                            <td class="fw-bold text-success">
                                <c:choose>
                                    <c:when test="${item.hasDiscount()}">
                                        ₹<fmt:formatNumber value="${item.discountPrice}" maxFractionDigits="2"/>
                                        <span class="badge bg-primary ms-1">${item.discountPercentage}% OFF</span>
                                    </c:when>
                                    <c:otherwise>
                                        -
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <label class="switch">
                                    <input type="checkbox" ${item.available ? 'checked' : ''} onchange="toggleItemAvailability(${item.id}, this.checked)">
                                    <span class="slider"></span>
                                </label>
                            </td>
                            <td class="text-end">
                                <a href="${pageContext.request.contextPath}/admin/items/edit?id=${item.id}" class="btn btn-sm btn-outline-secondary rounded-pill px-3 me-1">
                                    Edit
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/items/delete?id=${item.id}" class="btn btn-sm btn-outline-danger rounded-pill px-3" onclick="return confirm('Are you sure you want to delete ${item.name}?')">
                                    Delete
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

</main>

<script>
    async function toggleItemAvailability(id, isAvailable) {
        try {
            const formData = new URLSearchParams();
            formData.append('id', id);
            formData.append('available', isAvailable);

            const res = await fetch('${pageContext.request.contextPath}/admin/items/toggle', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: formData.toString()
            });

            const data = await res.json();
            if (data.success) {
                if (window.showToast) showToast('Updated', 'Item availability updated', 'success');
            } else {
                if (window.showToast) showToast('Error', data.message, 'error');
            }
        } catch (e) {
            console.error('Error toggling availability:', e);
        }
    }
</script>

<jsp:include page="/WEB-INF/views/footer.jsp"/>
