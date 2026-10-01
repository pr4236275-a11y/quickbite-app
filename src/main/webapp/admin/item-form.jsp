<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="${isEdit ? 'Edit Food Item' : 'Add Food Item'} - QuickBite Admin" scope="request"/>
<jsp:include page="/WEB-INF/views/header.jsp"/>

<main class="container my-4">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            
            <div class="d-flex align-items-center justify-content-between mb-3">
                <div>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb mb-1 small">
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/items">Food Items</a></li>
                            <li class="breadcrumb-item active" aria-current="page">${isEdit ? 'Edit Item' : 'New Item'}</li>
                        </ol>
                    </nav>
                    <h1 class="fs-3 fw-bold mb-0">${isEdit ? 'Edit Food Item' : 'Add New Food Item'}</h1>
                </div>
            </div>

            <div class="card border-0 shadow-sm rounded-4 p-4 bg-white">
                <form action="${pageContext.request.contextPath}/admin/items/${isEdit ? 'edit' : 'new'}" method="POST">
                    
                    <c:if test="${isEdit}">
                        <input type="hidden" name="id" value="${item.id}">
                    </c:if>

                    <div class="row g-3">
                        
                        <!-- Name & Category -->
                        <div class="col-md-8">
                            <label for="name" class="form-label small fw-bold text-muted">Item Name *</label>
                            <input type="text" class="form-control rounded-3" id="name" name="name" 
                                   value="${item.name}" placeholder="e.g. Farmhouse Supreme Pizza" required>
                        </div>

                        <div class="col-md-4">
                            <label for="categoryId" class="form-label small fw-bold text-muted">Category *</label>
                            <select class="form-select rounded-3" id="categoryId" name="categoryId" required>
                                <c:forEach var="cat" items="${categories}">
                                    <option value="${cat.id}" ${item.categoryId == cat.id ? 'selected' : ''}>${cat.name}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <!-- Description -->
                        <div class="col-12">
                            <label for="description" class="form-label small fw-bold text-muted">Description</label>
                            <textarea class="form-control rounded-3" id="description" name="description" rows="2" 
                                      placeholder="Brief tasty description of the food item...">${item.description}</textarea>
                        </div>

                        <!-- Pricing & Unit -->
                        <div class="col-md-4">
                            <label for="price" class="form-label small fw-bold text-muted">Original MRP (₹) *</label>
                            <input type="number" step="0.01" class="form-control rounded-3" id="price" name="price" 
                                   value="${item.price}" placeholder="249.00" required>
                        </div>

                        <div class="col-md-4">
                            <label for="discountPrice" class="form-label small fw-bold text-muted">Discounted Price (₹)</label>
                            <input type="number" step="0.01" class="form-control rounded-3" id="discountPrice" name="discountPrice" 
                                   value="${item.discountPrice}" placeholder="199.00">
                        </div>

                        <div class="col-md-4">
                            <label for="unit" class="form-label small fw-bold text-muted">Unit / Portion *</label>
                            <input type="text" class="form-control rounded-3" id="unit" name="unit" 
                                   value="${not empty item.unit ? item.unit : '1 pc'}" placeholder="e.g. 1 pc, 450g, Serves 1-2" required>
                        </div>

                        <!-- Image URL -->
                        <div class="col-md-8">
                            <label for="imageUrl" class="form-label small fw-bold text-muted">Image URL (Web / Unsplash) *</label>
                            <input type="url" class="form-control rounded-3" id="imageUrl" name="imageUrl" 
                                   value="${item.imageUrl}" placeholder="https://images.unsplash.com/..." 
                                   oninput="document.getElementById('previewImg').src = this.value" required>
                        </div>

                        <div class="col-md-4 text-center">
                            <label class="form-label small fw-bold text-muted d-block">Preview</label>
                            <img id="previewImg" src="${not empty item.imageUrl ? item.imageUrl : 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=200'}" 
                                 class="rounded-3 border" style="width: 70px; height: 70px; object-fit: cover;" 
                                 onerror="this.src='https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=200'">
                        </div>

                        <!-- Dietary Preference -->
                        <div class="col-md-4">
                            <label class="form-label small fw-bold text-muted d-block">Dietary Type *</label>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="isVeg" id="vegTrue" value="true" ${item.veg || empty item ? 'checked' : ''}>
                                <label class="form-check-label text-success fw-bold" for="vegTrue">🟢 Veg</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="isVeg" id="vegFalse" value="false" ${!item.veg && not empty item ? 'checked' : ''}>
                                <label class="form-check-label text-danger fw-bold" for="vegFalse">🔴 Non-Veg</label>
                            </div>
                        </div>

                        <!-- Flags -->
                        <div class="col-md-4">
                            <label class="form-label small fw-bold text-muted d-block">Visibility</label>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="checkbox" name="isAvailable" id="availCheck" value="true" ${item.available || empty item ? 'checked' : ''}>
                                <label class="form-check-label" for="availCheck">In Stock / Available</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="checkbox" name="isPopular" id="popCheck" value="true" ${item.popular ? 'checked' : ''}>
                                <label class="form-check-label" for="popCheck">🔥 Popular</label>
                            </div>
                        </div>

                        <!-- Delivery Mins & Rating -->
                        <div class="col-md-2">
                            <label for="deliveryTimeMins" class="form-label small fw-bold text-muted">Delivery (Mins)</label>
                            <input type="number" class="form-control rounded-3" id="deliveryTimeMins" name="deliveryTimeMins" 
                                   value="${not empty item.deliveryTimeMins ? item.deliveryTimeMins : 12}">
                        </div>

                        <div class="col-md-2">
                            <label for="rating" class="form-label small fw-bold text-muted">Rating</label>
                            <input type="number" step="0.1" class="form-control rounded-3" id="rating" name="rating" 
                                   value="${not empty item.rating ? item.rating : 4.5}">
                        </div>

                    </div>

                    <hr class="my-4">

                    <div class="d-flex justify-content-end gap-2">
                        <a href="${pageContext.request.contextPath}/admin/items" class="btn btn-outline-secondary rounded-pill px-4">
                            Cancel
                        </a>
                        <button type="submit" class="btn btn-danger rounded-pill px-5 fw-bold" style="background-color: var(--theme-red); border-color: var(--theme-red);">
                            ${isEdit ? 'Save Changes' : 'Create Item'}
                        </button>
                    </div>

                </form>
            </div>

        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/views/footer.jsp"/>
