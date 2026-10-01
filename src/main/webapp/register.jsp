<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Sign Up - QuickBite" scope="request"/>
<jsp:include page="/WEB-INF/views/header.jsp"/>

<main class="container my-5">
    <div class="row justify-content-center">
        <div class="col-md-6 col-lg-5">
            
            <div class="card border-0 shadow-sm rounded-4 p-4 bg-white" data-aos="zoom-in">
                
                <div class="text-center mb-4">
                    <div class="brand-title fs-2 mb-1">Quick<span>Bite</span></div>
                    <h1 class="fs-5 fw-bold text-dark">Create your account</h1>
                    <p class="text-muted small">Enjoy 10-minute grocery and food deliveries right to your door</p>
                </div>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger py-2 px-3 small rounded-3 mb-3 d-flex align-items-center gap-2">
                        <span>⚠️</span> <div>${error}</div>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/register" method="POST">
                    
                    <div class="mb-3">
                        <label for="name" class="form-label small fw-semibold text-muted">Full Name</label>
                        <input type="text" class="form-control rounded-3 py-2" id="name" name="name" 
                               placeholder="e.g. Rahul Sharma" value="${name}" required>
                    </div>

                    <div class="mb-3">
                        <label for="email" class="form-label small fw-semibold text-muted">Email Address</label>
                        <input type="email" class="form-control rounded-3 py-2" id="email" name="email" 
                               placeholder="name@example.com" value="${email}" required>
                    </div>

                    <div class="mb-3">
                        <label for="phone" class="form-label small fw-semibold text-muted">Phone Number</label>
                        <input type="tel" class="form-control rounded-3 py-2" id="phone" name="phone" 
                               placeholder="+91 98765 43210" value="${phone}">
                    </div>

                    <div class="row g-2 mb-4">
                        <div class="col-6">
                            <label for="password" class="form-label small fw-semibold text-muted">Password</label>
                            <input type="password" class="form-control rounded-3 py-2" id="password" name="password" 
                                   placeholder="••••••••" required>
                        </div>
                        <div class="col-6">
                            <label for="confirmPassword" class="form-label small fw-semibold text-muted">Confirm</label>
                            <input type="password" class="form-control rounded-3 py-2" id="confirmPassword" name="confirmPassword" 
                                   placeholder="••••••••" required>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-danger w-100 py-2 fw-bold rounded-3 mb-3" style="background-color: var(--theme-red); border-color: var(--theme-red);">
                        Create Account
                    </button>

                </form>

                <div class="text-center small text-muted">
                    Already have an account? 
                    <a href="${pageContext.request.contextPath}/login" class="text-danger fw-bold text-decoration-none">
                        Log in
                    </a>
                </div>

            </div>

        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/views/footer.jsp"/>
