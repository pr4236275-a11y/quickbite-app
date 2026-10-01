<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Login - QuickBite" scope="request"/>
<jsp:include page="/WEB-INF/views/header.jsp"/>

<main class="container my-5">
    <div class="row justify-content-center">
        <div class="col-md-5 col-lg-4">
            
            <div class="card border-0 shadow-sm rounded-4 p-4 bg-white" data-aos="zoom-in">
                
                <div class="text-center mb-4">
                    <div class="brand-title fs-2 mb-1">Quick<span>Bite</span></div>
                    <h1 class="fs-5 fw-bold text-dark">Craving delivered in 10 minutes</h1>
                    <p class="text-muted small">Log in to track orders, addresses and quick payments</p>
                </div>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger py-2 px-3 small rounded-3 mb-3 d-flex align-items-center gap-2">
                        <span>⚠️</span> <div>${error}</div>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/login" method="POST">
                    
                    <div class="mb-3">
                        <label for="email" class="form-label small fw-semibold text-muted">Email Address</label>
                        <input type="email" class="form-control rounded-3 py-2" id="email" name="email" 
                               placeholder="name@example.com" value="${email}" required>
                    </div>

                    <div class="mb-4">
                        <div class="d-flex justify-content-between align-items-center mb-1">
                            <label for="password" class="form-label small fw-semibold text-muted mb-0">Password</label>
                        </div>
                        <input type="password" class="form-control rounded-3 py-2" id="password" name="password" 
                               placeholder="••••••••" required>
                    </div>

                    <button type="submit" class="btn btn-danger w-100 py-2 fw-bold rounded-3 mb-3" style="background-color: var(--theme-red); border-color: var(--theme-red);">
                        Continue
                    </button>

                </form>

                <div class="text-center small text-muted">
                    Don't have an account? 
                    <a href="${pageContext.request.contextPath}/register" class="text-danger fw-bold text-decoration-none">
                        Sign up
                    </a>
                </div>

                <!-- One-click Demo Credentials Helper -->
                <div class="mt-4 pt-3 border-top">
                    <div class="small fw-bold text-muted mb-2 text-center">Quick Demo Login:</div>
                    <div class="d-grid gap-2">
                        <button type="button" class="btn btn-outline-secondary btn-sm rounded-3 text-start d-flex justify-content-between align-items-center" onclick="fillDemo('admin@quickbite.com', 'Admin@123')">
                            <span>👑 <strong>Admin</strong> (admin@quickbite.com)</span>
                            <span class="badge bg-secondary">Fill</span>
                        </button>
                        <button type="button" class="btn btn-outline-secondary btn-sm rounded-3 text-start d-flex justify-content-between align-items-center" onclick="fillDemo('user@quickbite.com', 'User@123')">
                            <span>👤 <strong>Customer</strong> (user@quickbite.com)</span>
                            <span class="badge bg-secondary">Fill</span>
                        </button>
                    </div>
                </div>

            </div>

        </div>
    </div>
</main>

<script>
    function fillDemo(email, pass) {
        document.getElementById('email').value = email;
        document.getElementById('password').value = pass;
    }
</script>

<jsp:include page="/WEB-INF/views/footer.jsp"/>
