<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Checkout - QuickBite" scope="request"/>
<jsp:include page="/WEB-INF/views/header.jsp"/>

<main class="container my-4">
    
    <div class="row g-4">
        
        <!-- Left Column: Address, Delivery & Payment Options -->
        <div class="col-lg-7">
            
            <div class="d-flex align-items-center gap-2 mb-3">
                <span class="delivery-badge fs-6"><span class="pulse-dot"></span> 10 MINS</span>
                <h1 class="fs-4 fw-bold mb-0">Delivery &amp; Payment</h1>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-danger py-2 px-3 small rounded-3 mb-3">
                    ⚠️ ${error}
                </div>
            </c:if>

            <form id="checkoutForm" action="${pageContext.request.contextPath}/checkout" method="POST">
                
                <!-- 1. Delivery Address Card -->
                <div class="card border-0 shadow-sm rounded-4 p-4 bg-white mb-4">
                    <h2 class="fs-5 fw-bold mb-3 d-flex align-items-center gap-2">
                        <span>📍</span> Delivery Address
                    </h2>

                    <c:choose>
                        <c:when test="${not empty addresses}">
                            <!-- Saved Addresses Options -->
                            <div class="mb-3">
                                <div class="form-check mb-2">
                                    <input class="form-check-input" type="radio" name="addressChoice" id="addrExisting" value="existing" checked onchange="toggleAddressForm(false)">
                                    <label class="form-check-label fw-bold text-dark" for="addrExisting">
                                        Use a Saved Address
                                    </label>
                                </div>

                                <div id="savedAddressesContainer" class="ps-4">
                                    <div class="row g-2">
                                        <c:forEach var="addr" items="${addresses}">
                                            <div class="col-12">
                                                <label class="p-3 border rounded-3 d-flex align-items-start gap-3 w-100 cursor-pointer ${addr.default ? 'border-success bg-light' : ''}">
                                                    <input type="radio" name="selectedAddressId" value="${addr.id}" ${addr.default ? 'checked' : ''} class="mt-1">
                                                    <div>
                                                        <div class="fw-bold text-dark">
                                                            ${addr.addressType}
                                                            <c:if test="${addr.default}"><span class="badge bg-success-subtle text-success ms-2">Default</span></c:if>
                                                        </div>
                                                        <div class="small text-muted">${addr.formattedAddress}</div>
                                                    </div>
                                                </label>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>

                                <div class="form-check mt-3">
                                    <input class="form-check-input" type="radio" name="addressChoice" id="addrNew" value="new" onchange="toggleAddressForm(true)">
                                    <label class="form-check-label fw-bold text-dark" for="addrNew">
                                        + Deliver to a Different Address
                                    </label>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <input type="hidden" name="addressChoice" value="new">
                        </c:otherwise>
                    </c:choose>

                    <!-- New Address Form (Hidden if saved selected) -->
                    <div id="newAddressForm" style="${empty addresses ? 'display: block;' : 'display: none;'}">
                        <div class="row g-2">
                            <div class="col-md-6 mb-2">
                                <label class="form-label small text-muted">Flat / House / Building No. *</label>
                                <input type="text" name="addressLine1" id="addressLine1" class="form-control rounded-3" placeholder="e.g. Flat 304, Sunshine Towers">
                            </div>
                            <div class="col-md-6 mb-2">
                                <label class="form-label small text-muted">Street / Area</label>
                                <input type="text" name="addressLine2" class="form-control rounded-3" placeholder="e.g. 100ft Road, Indiranagar">
                            </div>
                            <div class="col-md-6 mb-2">
                                <label class="form-label small text-muted">Nearby Landmark</label>
                                <input type="text" name="landmark" class="form-control rounded-3" placeholder="e.g. Opposite Metro Pillar 42">
                            </div>
                            <div class="col-md-6 mb-2">
                                <label class="form-label small text-muted">Pincode *</label>
                                <input type="text" name="pincode" id="pincode" class="form-control rounded-3" placeholder="560038" maxlength="10">
                            </div>
                            <div class="col-md-6 mb-2">
                                <label class="form-label small text-muted">City *</label>
                                <input type="text" name="city" id="city" class="form-control rounded-3" value="Bengaluru">
                            </div>
                            <div class="col-md-6 mb-2">
                                <label class="form-label small text-muted">Address Tag</label>
                                <select name="addressType" class="form-select rounded-3">
                                    <option value="Home">Home</option>
                                    <option value="Work">Work</option>
                                    <option value="Other">Other</option>
                                </select>
                            </div>
                            <div class="col-12 mt-2">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="saveAsDefault" value="true" id="saveDefault" checked>
                                    <label class="form-check-label small text-muted" for="saveDefault">
                                        Save as my primary delivery address
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="mt-3 pt-3 border-top">
                        <label class="form-label small text-muted">Delivery Instructions / Notes (Optional)</label>
                        <input type="text" name="orderNotes" class="form-control rounded-3" placeholder="e.g. Please ring bell twice or leave at door">
                    </div>

                </div>

                <!-- 2. Payment Method Card -->
                <div class="card border-0 shadow-sm rounded-4 p-4 bg-white mb-4">
                    <h2 class="fs-5 fw-bold mb-3 d-flex align-items-center gap-2">
                        <span>💳</span> Select Payment Mode
                    </h2>

                    <div class="d-flex flex-column gap-3">
                        
                        <!-- UPI Option -->
                        <label class="p-3 border rounded-3 d-flex align-items-center justify-content-between cursor-pointer payment-option-card">
                            <div class="d-flex align-items-center gap-3">
                                <input type="radio" name="paymentMethod" value="UPI" id="payUPI" checked onchange="togglePaymentDetails('UPI')">
                                <div>
                                    <div class="fw-bold text-dark">UPI Instant Payment (Google Pay / PhonePe / Paytm)</div>
                                    <div class="small text-muted">Fast &amp; contactless 1-click verification</div>
                                </div>
                            </div>
                            <span class="fs-4">⚡</span>
                        </label>

                        <!-- UPI Mock Box -->
                        <div id="upiMockBox" class="p-3 bg-light rounded-3 border">
                            <div class="d-flex align-items-center gap-3">
                                <div class="bg-white p-2 rounded border text-center shadow-sm">
                                    <!-- QR Code Mockup -->
                                    <svg width="64" height="64" viewBox="0 0 24 24" fill="currentColor">
                                        <path d="M2 2h8v8H2V2zm2 2v4h4V4H4zm-2 10h8v8H2v-8zm2 2v4h4v-4H4zm10-14h8v8h-8V2zm2 2v4h4V4h-4zm2 10h-2v2h2v-2zm-2 4h2v2h-2v-2zm4-4h2v2h-2v-2zm0 4h2v2h-2v-2zm-4 2h2v2h-2v-2z"></path>
                                    </svg>
                                </div>
                                <div>
                                    <div class="fw-bold small text-dark">Scan &amp; Pay on UPI App or Enter UPI ID</div>
                                    <div class="input-group input-group-sm mt-1">
                                        <input type="text" class="form-control" placeholder="yourname@okhdfcbank" value="user@blinkit">
                                        <span class="input-group-text bg-success text-white fw-bold">Verified</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- COD Option -->
                        <label class="p-3 border rounded-3 d-flex align-items-center justify-content-between cursor-pointer payment-option-card">
                            <div class="d-flex align-items-center gap-3">
                                <input type="radio" name="paymentMethod" value="COD" id="payCOD" onchange="togglePaymentDetails('COD')">
                                <div>
                                    <div class="fw-bold text-dark">Cash on Delivery (COD)</div>
                                    <div class="small text-muted">Pay via Cash or QR code when delivery partner arrives</div>
                                </div>
                            </div>
                            <span class="fs-4">💵</span>
                        </label>

                    </div>
                </div>

                <!-- Submit Button -->
                <button type="submit" class="btn btn-danger w-100 py-3 fw-bold rounded-4 fs-5 shadow-sm" style="background-color: var(--theme-red); border-color: var(--theme-red);">
                    Place Order • ₹<fmt:formatNumber value="${cart.grandTotal}" maxFractionDigits="2"/>
                </button>

            </form>

        </div>

        <!-- Right Column: Order Bill Summary -->
        <div class="col-lg-5">
            <div class="card border-0 shadow-sm rounded-4 p-4 bg-white sticky-top" style="top: 80px;">
                <h2 class="fs-5 fw-bold mb-3 d-flex align-items-center justify-content-between">
                    <span>Order Summary</span>
                    <span class="badge bg-light text-dark border">${cart.totalQuantity} items</span>
                </h2>

                <!-- Items list -->
                <div class="overflow-auto pe-1 mb-3" style="max-height: 280px;">
                    <c:forEach var="ci" items="${cart.itemsList}">
                        <div class="d-flex align-items-center gap-3 py-2 border-bottom">
                            <img src="${ci.foodItem.imageUrl}" alt="${ci.foodItem.name}" class="rounded-3" style="width: 48px; height: 48px; object-fit: cover;" onerror="this.src='https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=100'">
                            <div class="flex-grow-1">
                                <div class="fw-bold small text-dark line-clamp-1">${ci.foodItem.name}</div>
                                <div class="text-muted" style="font-size: 11px;">Qty: ${ci.quantity} × ₹<fmt:formatNumber value="${ci.foodItem.effectivePrice}" maxFractionDigits="0"/></div>
                            </div>
                            <div class="fw-bold small text-dark">
                                ₹<fmt:formatNumber value="${ci.itemTotal}" maxFractionDigits="2"/>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <!-- Bill breakdown -->
                <div class="bill-line d-flex justify-content-between small text-muted mb-2">
                    <span>Item Total</span>
                    <span>₹<fmt:formatNumber value="${cart.subtotal}" maxFractionDigits="2"/></span>
                </div>
                <div class="bill-line d-flex justify-content-between small text-muted mb-2 ${cart.deliveryFee == 0 ? 'text-success fw-bold' : ''}">
                    <span>Delivery Partner Fee</span>
                    <span>
                        <c:choose>
                            <c:when test="${cart.deliveryFee == 0}">
                                <del class="text-muted me-1">₹25.00</del> FREE
                            </c:when>
                            <c:otherwise>
                                ₹<fmt:formatNumber value="${cart.deliveryFee}" maxFractionDigits="2"/>
                            </c:otherwise>
                        </c:choose>
                    </span>
                </div>
                <div class="bill-line d-flex justify-content-between small text-muted mb-2">
                    <span>Handling Fee</span>
                    <span>₹<fmt:formatNumber value="${cart.handlingFee}" maxFractionDigits="2"/></span>
                </div>

                <hr class="my-2">

                <div class="d-flex justify-content-between fs-5 fw-bold text-dark pt-1">
                    <span>To Pay</span>
                    <span class="text-danger">₹<fmt:formatNumber value="${cart.grandTotal}" maxFractionDigits="2"/></span>
                </div>

                <div class="mt-3 p-3 bg-light rounded-3 small text-muted border">
                    <div class="fw-bold text-dark mb-1">⚡ Cancellation Policy</div>
                    Orders cannot be cancelled once packed by the restaurant to ensure zero food wastage.
                </div>
            </div>
        </div>

    </div>

</main>

<script>
    function toggleAddressForm(isNew) {
        const form = document.getElementById('newAddressForm');
        if (form) form.style.display = isNew ? 'block' : 'none';
    }

    function togglePaymentDetails(mode) {
        const upiBox = document.getElementById('upiMockBox');
        if (upiBox) {
            upiBox.style.display = mode === 'UPI' ? 'block' : 'none';
        }
    }
</script>

<jsp:include page="/WEB-INF/views/footer.jsp"/>
