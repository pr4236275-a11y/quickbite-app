/**
 * Blinkit Interactive Cart & Stepper System
 * Handles seamless AJAX updates, morphing buttons, slide-in drawer, and fly-to-cart animations.
 */

const BlinkitCart = {
    cartData: {
        items: [],
        totalQuantity: 0,
        itemCount: 0,
        subtotal: 0,
        deliveryFee: 0,
        handlingFee: 4,
        grandTotal: 0,
        isFreeDeliveryEligible: false,
        amountNeededForFreeDelivery: 199,
        isEmpty: true
    },

    contextPath: '',

    init(contextPath = '') {
        this.contextPath = contextPath;
        this.fetchCart();
        this.bindEvents();
    },

    bindEvents() {
        // Overlay close
        const overlay = document.getElementById('cartDrawerOverlay');
        if (overlay) {
            overlay.addEventListener('click', () => this.closeDrawer());
        }

        // Close button
        const closeBtn = document.getElementById('closeCartDrawerBtn');
        if (closeBtn) {
            closeBtn.addEventListener('click', () => this.closeDrawer());
        }

        // Header cart triggers
        const cartTriggers = document.querySelectorAll('.trigger-cart-drawer');
        cartTriggers.forEach(btn => {
            btn.addEventListener('click', (e) => {
                e.preventDefault();
                this.openDrawer();
            });
        });
    },

    openDrawer() {
        const drawer = document.getElementById('cartDrawer');
        const overlay = document.getElementById('cartDrawerOverlay');
        if (drawer && overlay) {
            overlay.classList.add('active');
            drawer.classList.add('active');
            document.body.style.overflow = 'hidden';

            // Optional GSAP animation if loaded
            if (window.gsap) {
                gsap.fromTo(drawer, { x: '100%' }, { x: '0%', duration: 0.35, ease: 'power2.out' });
            }
        }
    },

    closeDrawer() {
        const drawer = document.getElementById('cartDrawer');
        const overlay = document.getElementById('cartDrawerOverlay');
        if (drawer && overlay) {
            if (window.gsap) {
                gsap.to(drawer, {
                    x: '100%',
                    duration: 0.25,
                    ease: 'power2.in',
                    onComplete: () => {
                        drawer.classList.remove('active');
                        overlay.classList.remove('active');
                        document.body.style.overflow = '';
                    }
                });
            } else {
                drawer.classList.remove('active');
                overlay.classList.remove('active');
                document.body.style.overflow = '';
            }
        }
    },

    async fetchCart() {
        try {
            const res = await fetch(`${this.contextPath}/cart?action=get`, {
                headers: { 'Accept': 'application/json' }
            });
            if (res.ok) {
                const data = await res.json();
                this.cartData = data;
                this.updateUI();
            }
        } catch (err) {
            console.error('Error fetching cart state:', err);
        }
    },

    async addItem(foodId, sourceElement = null) {
        try {
            // Trigger fly-to-cart animation if element provided
            if (sourceElement) {
                this.animateFlyToCart(sourceElement);
            }

            const formData = new URLSearchParams();
            formData.append('action', 'add');
            formData.append('foodId', foodId);
            formData.append('qty', '1');

            const res = await fetch(`${this.contextPath}/cart`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: formData.toString()
            });

            const json = await res.json();
            if (json.success) {
                this.cartData = json.data;
                this.updateUI();
                if (window.showToast) {
                    showToast('Added to cart', 'Item successfully added to your bag', 'success');
                }
            } else {
                if (window.showToast) showToast('Notice', json.message, 'error');
            }
        } catch (err) {
            console.error('Error adding item to cart:', err);
        }
    },

    async updateQuantity(foodId, newQty) {
        try {
            const formData = new URLSearchParams();
            formData.append('action', 'update');
            formData.append('foodId', foodId);
            formData.append('qty', newQty);

            const res = await fetch(`${this.contextPath}/cart`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: formData.toString()
            });

            const json = await res.json();
            if (json.success) {
                this.cartData = json.data;
                this.updateUI();
            }
        } catch (err) {
            console.error('Error updating quantity:', err);
        }
    },

    async removeItem(foodId) {
        try {
            const formData = new URLSearchParams();
            formData.append('action', 'remove');
            formData.append('foodId', foodId);

            const res = await fetch(`${this.contextPath}/cart`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: formData.toString()
            });

            const json = await res.json();
            if (json.success) {
                this.cartData = json.data;
                this.updateUI();
                if (window.showToast) {
                    showToast('Item removed', 'Item removed from your cart', 'info');
                }
            }
        } catch (err) {
            console.error('Error removing item:', err);
        }
    },

    updateUI() {
        this.updateHeaderBadges();
        this.updateCardSteppers();
        this.renderDrawerContent();
        this.updateMobileFloatBar();
    },

    updateHeaderBadges() {
        const badgeCount = document.querySelectorAll('.cart-badge-count');
        const badgeTotal = document.querySelectorAll('.cart-badge-total');
        const count = this.cartData.totalQuantity || 0;
        const total = parseFloat(this.cartData.grandTotal || 0).toFixed(0);

        badgeCount.forEach(el => el.textContent = count);
        badgeTotal.forEach(el => el.textContent = '₹' + total);

        // Header Cart Button Full Text
        const headerBtn = document.getElementById('headerCartBtn');
        if (headerBtn) {
            if (count > 0) {
                headerBtn.innerHTML = `
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                        <circle cx="9" cy="21" r="1"></circle>
                        <circle cx="20" cy="21" r="1"></circle>
                        <path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"></path>
                    </svg>
                    <span>${count} items</span>
                    <span class="cart-total-badge">₹${total}</span>
                `;
            } else {
                headerBtn.innerHTML = `
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                        <circle cx="9" cy="21" r="1"></circle>
                        <circle cx="20" cy="21" r="1"></circle>
                        <path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"></path>
                    </svg>
                    <span>My Cart</span>
                `;
            }
        }
    },

    updateCardSteppers() {
        // Map food items to quantities
        const qtyMap = {};
        if (this.cartData.items) {
            this.cartData.items.forEach(item => {
                qtyMap[item.id] = item.quantity;
            });
        }

        // Find all stepper containers on the page
        const stepperContainers = document.querySelectorAll('.stepper-container[data-food-id]');
        stepperContainers.forEach(container => {
            const foodId = parseInt(container.getAttribute('data-food-id'));
            const qty = qtyMap[foodId] || 0;

            if (qty > 0) {
                container.innerHTML = `
                    <div class="stepper-active">
                        <button type="button" class="stepper-btn" onclick="BlinkitCart.updateQuantity(${foodId}, ${qty - 1})">−</button>
                        <span class="stepper-qty">${qty}</span>
                        <button type="button" class="stepper-btn" onclick="BlinkitCart.updateQuantity(${foodId}, ${qty + 1})">+</button>
                    </div>
                `;
            } else {
                container.innerHTML = `
                    <button type="button" class="btn-add-food" onclick="BlinkitCart.addItem(${foodId}, this)">
                        ADD <span>+</span>
                    </button>
                `;
            }
        });
    },

    renderDrawerContent() {
        const body = document.getElementById('cartDrawerItemsList');
        const footer = document.getElementById('cartDrawerFooter');
        const deliveryBanner = document.getElementById('cartDeliveryBanner');

        if (!body) return;

        if (this.cartData.isEmpty || !this.cartData.items || this.cartData.items.length === 0) {
            body.innerHTML = `
                <div class="cart-empty-state">
                    <div class="cart-empty-icon">🛒</div>
                    <div class="cart-empty-title">Your cart is empty</div>
                    <div class="cart-empty-text">Looks like you haven't added anything to your cart yet. Discover fresh foods!</div>
                    <button type="button" class="btn btn-outline-success rounded-pill px-4 fw-bold" onclick="BlinkitCart.closeDrawer()">
                        Start Ordering
                    </button>
                </div>
            `;
            if (footer) footer.style.display = 'none';
            if (deliveryBanner) deliveryBanner.style.display = 'none';
            return;
        }

        if (deliveryBanner) {
            deliveryBanner.style.display = 'flex';
            if (this.cartData.isFreeDeliveryEligible) {
                deliveryBanner.innerHTML = `
                    <span>🎉</span>
                    <div><strong>Free Delivery Unlocked!</strong> You saved ₹25 on delivery fee.</div>
                `;
            } else {
                const needed = parseFloat(this.cartData.amountNeededForFreeDelivery || 0).toFixed(0);
                deliveryBanner.innerHTML = `
                    <span>⚡</span>
                    <div>Add items worth <strong>₹${needed}</strong> more to get <strong>FREE delivery</strong></div>
                `;
            }
        }

        let itemsHtml = `
            <div class="cart-items-card">
                <div class="d-flex justify-content-between align-items-center mb-2">
                    <span class="fw-bold fs-6 text-dark">Items in Cart (${this.cartData.totalQuantity})</span>
                    <button type="button" class="btn btn-sm text-danger p-0" onclick="BlinkitCart.clearCart()">Clear All</button>
                </div>
        `;

        this.cartData.items.forEach(item => {
            const price = parseFloat(item.effectivePrice).toFixed(0);
            const total = parseFloat(item.itemTotal).toFixed(0);
            itemsHtml += `
                <div class="cart-item-row">
                    <img src="${item.imageUrl}" alt="${item.name}" class="cart-item-img" onerror="this.src='https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=100'">
                    <div class="cart-item-info">
                        <div class="cart-item-name">${item.name}</div>
                        <div class="cart-item-unit">${item.unit || ''}</div>
                        <div class="cart-item-price">₹${price}</div>
                    </div>
                    <div class="stepper-active" style="width: 78px; height: 30px;">
                        <button type="button" class="stepper-btn" onclick="BlinkitCart.updateQuantity(${item.id}, ${item.quantity - 1})">−</button>
                        <span class="stepper-qty">${item.quantity}</span>
                        <button type="button" class="stepper-btn" onclick="BlinkitCart.updateQuantity(${item.id}, ${item.quantity + 1})">+</button>
                    </div>
                </div>
            `;
        });

        itemsHtml += `</div>`;

        // Bill Breakdown
        const subtotal = parseFloat(this.cartData.subtotal).toFixed(2);
        const deliveryFee = parseFloat(this.cartData.deliveryFee).toFixed(2);
        const handlingFee = parseFloat(this.cartData.handlingFee).toFixed(2);
        const grandTotal = parseFloat(this.cartData.grandTotal).toFixed(2);

        itemsHtml += `
            <div class="cart-bill-card">
                <div class="cart-bill-title">Bill Details</div>
                <div class="bill-line">
                    <span>Items Total</span>
                    <span>₹${subtotal}</span>
                </div>
                <div class="bill-line ${this.cartData.deliveryFee == 0 ? 'free-tag' : ''}">
                    <span>Delivery Partner Fee</span>
                    <span>${this.cartData.deliveryFee == 0 ? '<del class="text-muted me-1">₹25</del> FREE' : '₹' + deliveryFee}</span>
                </div>
                <div class="bill-line">
                    <span>Handling Fee</span>
                    <span>₹${handlingFee}</span>
                </div>
                <div class="bill-line total-line">
                    <span>Grand Total</span>
                    <span>₹${grandTotal}</span>
                </div>
            </div>

            <div class="p-3 bg-white rounded-3 border mb-3 text-muted" style="font-size: 11px; line-height: 1.4;">
                <div class="fw-bold text-dark mb-1">⚡ Quickbite 10-Minute Promise</div>
                Orders are packed with hygiene and delivered in lightning speed right to your doorstep.
            </div>
        `;

        body.innerHTML = itemsHtml;

        if (footer) {
            footer.style.display = 'block';
            footer.innerHTML = `
                <a href="${this.contextPath}/checkout" class="btn-proceed-pay">
                    <span>Proceed to Checkout</span>
                    <span class="d-flex align-items-center gap-1">₹${grandTotal} →</span>
                </a>
            `;
        }
    },

    updateMobileFloatBar() {
        const floatBar = document.getElementById('mobileCartFloatBar');
        if (!floatBar) return;

        const count = this.cartData.totalQuantity || 0;
        const total = parseFloat(this.cartData.grandTotal || 0).toFixed(0);

        if (count > 0) {
            floatBar.classList.add('visible');
            floatBar.innerHTML = `
                <div class="mobile-float-left">
                    <span>🛒</span>
                    <span>${count} items • ₹${total}</span>
                </div>
                <div class="mobile-float-right">
                    <span>View Cart</span>
                    <span>→</span>
                </div>
            `;
        } else {
            floatBar.classList.remove('visible');
        }
    },

    async clearCart() {
        try {
            const formData = new URLSearchParams();
            formData.append('action', 'clear');

            const res = await fetch(`${this.contextPath}/cart`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: formData.toString()
            });

            const json = await res.json();
            if (json.success) {
                this.cartData = json.data;
                this.updateUI();
            }
        } catch (err) {
            console.error('Error clearing cart:', err);
        }
    },

    animateFlyToCart(sourceElement) {
        const cartIcon = document.getElementById('headerCartBtn') || document.querySelector('.trigger-cart-drawer');
        if (!cartIcon || !sourceElement) return;

        const card = sourceElement.closest('.food-card');
        const img = card ? card.querySelector('.food-card-img') : null;
        if (!img) return;

        const imgRect = img.getBoundingClientRect();
        const cartRect = cartIcon.getBoundingClientRect();

        const flyImg = document.createElement('img');
        flyImg.src = img.src;
        flyImg.className = 'flying-cart-img';
        flyImg.style.top = `${imgRect.top}px`;
        flyImg.style.left = `${imgRect.left}px`;
        flyImg.style.width = `${imgRect.width}px`;
        flyImg.style.height = `${imgRect.height}px`;
        document.body.appendChild(flyImg);

        if (window.gsap) {
            gsap.to(flyImg, {
                top: cartRect.top + 10,
                left: cartRect.left + 20,
                width: 20,
                height: 20,
                opacity: 0.2,
                duration: 0.6,
                ease: 'power2.inOut',
                onComplete: () => {
                    flyImg.remove();
                    // Jiggle cart button
                    gsap.fromTo(cartIcon, { scale: 1 }, {
                        scale: 1.15,
                        duration: 0.15,
                        yoyo: true,
                        repeat: 1,
                        ease: 'power1.inOut'
                    });
                }
            });
        } else {
            setTimeout(() => {
                flyImg.remove();
            }, 600);
        }
    }
};

window.BlinkitCart = BlinkitCart;
window.QuickbiteCart = BlinkitCart;
