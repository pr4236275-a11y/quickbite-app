<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- BLINKIT SLIDE-IN CART DRAWER -->
<div id="cartDrawerOverlay" class="cart-drawer-overlay"></div>

<aside id="cartDrawer" class="cart-drawer" aria-label="Shopping Cart">
    <!-- Header -->
    <div class="cart-drawer-header">
        <div class="cart-drawer-title">
            <span>My Cart</span>
        </div>
        <button type="button" id="closeCartDrawerBtn" class="btn-close-drawer" aria-label="Close cart drawer">✕</button>
    </div>

    <!-- 10-Minute Delivery Banner -->
    <div id="cartDeliveryBanner" class="cart-delivery-strip" style="display: none;">
        <span>⚡</span>
        <div>Delivery in <strong>10 minutes</strong> to your doorstep</div>
    </div>

    <!-- Items List Body -->
    <div id="cartDrawerItemsList" class="cart-drawer-body">
        <!-- Rendered reactively via cart.js -->
        <div class="cart-empty-state">
            <div class="cart-empty-icon">🛒</div>
            <div class="cart-empty-title">Your cart is empty</div>
            <div class="cart-empty-text">Add your favourite food items to get them delivered in 10 minutes!</div>
        </div>
    </div>

    <!-- Footer Checkout Bar -->
    <div id="cartDrawerFooter" class="cart-drawer-footer" style="display: none;">
        <!-- Rendered reactively via cart.js -->
    </div>
</aside>

<!-- FLOATING VIEW CART BAR (FOR MOBILE SCREENS) -->
<div id="mobileCartFloatBar" class="mobile-cart-float-bar trigger-cart-drawer">
    <div class="mobile-float-left">
        <span>🛒</span>
        <span class="cart-badge-count">0</span> items • <span class="cart-badge-total">₹0</span>
    </div>
    <div class="mobile-float-right">
        <span>View Cart</span>
        <span>→</span>
    </div>
</div>
