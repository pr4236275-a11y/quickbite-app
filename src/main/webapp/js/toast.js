/**
 * Blinkit Custom Toast Notification System
 */
const BlinkitToast = {
    container: null,

    init() {
        if (!this.container) {
            let existing = document.getElementById('blinkitToastContainer');
            if (!existing) {
                this.container = document.createElement('div');
                this.container.id = 'blinkitToastContainer';
                this.container.className = 'toast-container-custom';
                document.body.appendChild(this.container);
            } else {
                this.container = existing;
            }
        }
    },

    show(title, desc = '', type = 'success', duration = 3000) {
        this.init();

        const toast = document.createElement('div');
        toast.className = `blinkit-toast ${type === 'error' ? 'toast-error' : ''}`;

        const icon = type === 'error' ? '⚠️' : '✅';
        toast.innerHTML = `
            <div style="font-size: 20px;">${icon}</div>
            <div>
                <div class="toast-msg-title">${title}</div>
                ${desc ? `<div class="toast-msg-desc">${desc}</div>` : ''}
            </div>
        `;

        this.container.appendChild(toast);

        // Auto remove
        setTimeout(() => {
            toast.style.opacity = '0';
            toast.style.transform = 'translateY(-10px)';
            toast.style.transition = 'all 0.25s ease';
            setTimeout(() => {
                if (toast.parentNode) {
                    toast.parentNode.removeChild(toast);
                }
            }, 300);
        }, duration);
    }
};

window.BlinkitToast = BlinkitToast;
window.QuickbiteToast = BlinkitToast;
window.showToast = (title, desc, type) => BlinkitToast.show(title, desc, type);
