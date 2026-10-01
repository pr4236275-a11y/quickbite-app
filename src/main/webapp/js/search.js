/**
 * Blinkit Live Search & Autocomplete
 */

const BlinkitSearch = {
    debounceTimer: null,
    contextPath: '',

    init(contextPath = '') {
        this.contextPath = contextPath;
        const input = document.getElementById('mainSearchInput');
        const clearBtn = document.getElementById('searchClearBtn');
        const dropdown = document.getElementById('searchSuggestionsDropdown');

        if (!input || !dropdown) return;

        // Input typing listener with debounce
        input.addEventListener('input', (e) => {
            const query = e.target.value.trim();
            if (clearBtn) {
                clearBtn.style.display = query.length > 0 ? 'block' : 'none';
            }

            clearTimeout(this.debounceTimer);
            if (query.length < 2) {
                dropdown.style.display = 'none';
                dropdown.innerHTML = '';
                return;
            }

            this.debounceTimer = setTimeout(() => {
                this.fetchSuggestions(query, dropdown);
            }, 250);
        });

        // Clear button
        if (clearBtn) {
            clearBtn.addEventListener('click', () => {
                input.value = '';
                clearBtn.style.display = 'none';
                dropdown.style.display = 'none';
                input.focus();
            });
        }

        // Click outside closes dropdown
        document.addEventListener('click', (e) => {
            if (!input.contains(e.target) && !dropdown.contains(e.target)) {
                dropdown.style.display = 'none';
            }
        });

        // Form submit or enter key
        const form = document.getElementById('mainSearchForm');
        if (form) {
            form.addEventListener('submit', (e) => {
                const query = input.value.trim();
                if (!query) {
                    e.preventDefault();
                }
            });
        }
    },

    async fetchSuggestions(query, dropdown) {
        try {
            const res = await fetch(`${this.contextPath}/api/search?q=${encodeURIComponent(query)}`);
            if (!res.ok) return;

            const items = await res.json();
            if (!items || items.length === 0) {
                dropdown.innerHTML = `
                    <div class="p-3 text-center text-muted fs-7">
                        No food items found matching "<strong>${this.escapeHtml(query)}</strong>"
                    </div>
                `;
                dropdown.style.display = 'block';
                return;
            }

            let html = '';
            items.forEach(item => {
                const dietIcon = item.isVeg ? '🟢 Veg' : '🔴 Non-Veg';
                html += `
                    <div class="suggestion-item" onclick="window.location.href='${this.contextPath}/search?q=${encodeURIComponent(item.name)}'">
                        <img src="${item.imageUrl}" alt="${item.name}" class="suggestion-thumb" onerror="this.src='https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=100'">
                        <div class="suggestion-info">
                            <div class="suggestion-title">${this.highlightMatch(item.name, query)}</div>
                            <div class="suggestion-meta">
                                <span>${item.categoryName}</span> • <span>${item.unit || ''}</span> • <span>${dietIcon}</span>
                            </div>
                        </div>
                        <div class="suggestion-price">₹${item.price}</div>
                    </div>
                `;
            });

            html += `
                <div class="p-2 text-center bg-light border-top">
                    <a href="${this.contextPath}/search?q=${encodeURIComponent(query)}" class="text-success fw-bold fs-7 text-decoration-none">
                        See all results for "${this.escapeHtml(query)}" →
                    </a>
                </div>
            `;

            dropdown.innerHTML = html;
            dropdown.style.display = 'block';

        } catch (err) {
            console.error('Error fetching search suggestions:', err);
        }
    },

    highlightMatch(text, query) {
        if (!query) return this.escapeHtml(text);
        const regex = new RegExp(`(${query.replace(/[-[\]{}()*+?.,\\^$|#\s]/g, '\\$&')})`, 'gi');
        return this.escapeHtml(text).replace(regex, '<span class="text-success fw-bold">$1</span>');
    },

    escapeHtml(str) {
        if (!str) return '';
        return str.replace(/[&<>"']/g, m => ({
            '&': '&amp;',
            '<': '&lt;',
            '>': '&gt;',
            '"': '&quot;',
            "'": '&#39;'
        })[m]);
    }
};

window.BlinkitSearch = BlinkitSearch;
window.QuickbiteSearch = BlinkitSearch;
