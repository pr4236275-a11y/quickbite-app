<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Manage Categories - QuickBite Admin" scope="request"/>
<jsp:include page="/WEB-INF/views/header.jsp"/>

<main class="container my-4">

    <!-- Header Actions -->
    <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-4 pb-3 border-bottom">
        <div>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-1 small">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
                    <li class="breadcrumb-item active" aria-current="page">Categories</li>
                </ol>
            </nav>
            <h1 class="fs-3 fw-bold mb-0">Food Categories (${categories.size()})</h1>
        </div>
        <div>
            <button type="button" class="btn btn-danger rounded-pill fw-bold" style="background-color: var(--theme-red); border-color: var(--theme-red);" 
                    data-bs-toggle="modal" data-bs-target="#addCategoryModal">
                + Add Category
            </button>
        </div>
    </div>

    <!-- Categories Table -->
    <div class="card border-0 shadow-sm rounded-4 bg-white overflow-hidden">
        <div class="table-responsive">
            <table class="table align-middle table-hover mb-0">
                <thead class="table-light">
                    <tr class="small text-muted">
                        <th>Image</th>
                        <th>Name &amp; Slug</th>
                        <th>Description</th>
                        <th>Display Order</th>
                        <th>Items Count</th>
                        <th>Status</th>
                        <th class="text-end">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="cat" items="${categories}">
                        <tr>
                            <td style="width: 70px;">
                                <img src="${cat.imageUrl}" alt="${cat.name}" class="rounded-circle" style="width: 48px; height: 48px; object-fit: cover;" onerror="this.src='https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=100'">
                            </td>
                            <td>
                                <div class="fw-bold text-dark">${cat.name}</div>
                                <div class="text-muted small"><code>${cat.slug}</code></div>
                            </td>
                            <td class="small text-muted">${cat.description}</td>
                            <td>
                                <span class="badge bg-light text-dark border">#${cat.displayOrder}</span>
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/admin/items?cat=${cat.id}" class="badge bg-success-subtle text-success text-decoration-none">
                                    ${cat.itemCount} Items
                                </a>
                            </td>
                            <td>
                                <span class="badge ${cat.active ? 'bg-success' : 'bg-secondary'}">
                                    ${cat.active ? 'Active' : 'Hidden'}
                                </span>
                            </td>
                            <td class="text-end">
                                <button type="button" class="btn btn-sm btn-outline-secondary rounded-pill px-3 me-1" 
                                        onclick="openEditCategoryModal(${cat.id}, '${cat.name}', '${cat.slug}', '${cat.description}', '${cat.imageUrl}', ${cat.displayOrder}, ${cat.active})">
                                    Edit
                                </button>
                                <form action="${pageContext.request.contextPath}/admin/categories" method="POST" class="d-inline" onsubmit="return confirm('Delete category ${cat.name}?')">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="id" value="${cat.id}">
                                    <button type="submit" class="btn btn-sm btn-outline-danger rounded-pill px-3">
                                        Delete
                                    </button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

</main>

<!-- Add Category Modal -->
<div class="modal fade" id="addCategoryModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content rounded-4 border-0 shadow">
            <div class="modal-header border-0 pb-0">
                <h5 class="modal-title fw-bold">Add New Category</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/categories" method="POST">
                <input type="hidden" name="action" value="add">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label small fw-bold">Category Name *</label>
                        <input type="text" name="name" class="form-control rounded-3" placeholder="e.g. Italian Pastas" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold">Slug (Optional)</label>
                        <input type="text" name="slug" class="form-control rounded-3" placeholder="e.g. italian-pastas">
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold">Description</label>
                        <textarea name="description" class="form-control rounded-3" rows="2" placeholder="Creamy Alfredo and fiery Arrabbiata pastas..."></textarea>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold">Image URL *</label>
                        <input type="url" name="imageUrl" class="form-control rounded-3" placeholder="https://images.unsplash.com/..." required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold">Display Order</label>
                        <input type="number" name="displayOrder" class="form-control rounded-3" value="10">
                    </div>
                </div>
                <div class="modal-footer border-0">
                    <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-success rounded-pill px-4 fw-bold">Save Category</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Edit Category Modal -->
<div class="modal fade" id="editCategoryModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content rounded-4 border-0 shadow">
            <div class="modal-header border-0 pb-0">
                <h5 class="modal-title fw-bold">Edit Category</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/categories" method="POST">
                <input type="hidden" name="action" value="edit">
                <input type="hidden" name="id" id="editCatId">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label small fw-bold">Category Name *</label>
                        <input type="text" name="name" id="editCatName" class="form-control rounded-3" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold">Slug *</label>
                        <input type="text" name="slug" id="editCatSlug" class="form-control rounded-3" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold">Description</label>
                        <textarea name="description" id="editCatDesc" class="form-control rounded-3" rows="2"></textarea>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold">Image URL *</label>
                        <input type="url" name="imageUrl" id="editCatImage" class="form-control rounded-3" required>
                    </div>
                    <div class="row g-2 mb-2">
                        <div class="col-6">
                            <label class="form-label small fw-bold">Display Order</label>
                            <input type="number" name="displayOrder" id="editCatOrder" class="form-control rounded-3">
                        </div>
                        <div class="col-6 d-flex align-items-center pt-4">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" name="active" value="true" id="editCatActive">
                                <label class="form-check-label small" for="editCatActive">Active</label>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer border-0">
                    <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-success rounded-pill px-4 fw-bold">Update Category</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    function openEditCategoryModal(id, name, slug, desc, img, order, active) {
        document.getElementById('editCatId').value = id;
        document.getElementById('editCatName').value = name;
        document.getElementById('editCatSlug').value = slug;
        document.getElementById('editCatDesc').value = desc;
        document.getElementById('editCatImage').value = img;
        document.getElementById('editCatOrder').value = order;
        document.getElementById('editCatActive').checked = active;

        new bootstrap.Modal(document.getElementById('editCategoryModal')).show();
    }
</script>

<jsp:include page="/WEB-INF/views/footer.jsp"/>
