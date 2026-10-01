/**
 * QuickBite GSAP, Parallax & Scroll Animation System
 * Smooth scroll-driven hero transforms, parallax satellite cards,
 * zoom/scale transitions, and horizontal product carousels.
 */

document.addEventListener('DOMContentLoaded', () => {
    // 1. Initialize AOS (Animate on Scroll)
    if (window.AOS) {
        AOS.init({
            duration: 600,
            easing: 'ease-out-cubic',
            once: true,
            offset: 40
        });
    }

    // 2. Cinematic Hero Entrance (GSAP Stagger)
    const heroSection = document.getElementById('quickbiteHero');
    const heroTitle = document.querySelector('.hero-main-title');
    const heroDesc = document.querySelector('.hero-description');
    const heroSearch = document.querySelector('.hero-mega-search-wrapper');
    const heroCuisines = document.querySelector('.hero-popular-cuisines');
    const heroBadges = document.querySelector('.hero-feature-badges');
    const heroCenterpiece = document.getElementById('heroCenterpiece');
    const floatingCard1 = document.getElementById('floatingCard1');
    const floatingCard2 = document.getElementById('floatingCard2');
    const floatingBadge1 = document.getElementById('floatingBadge1');
    const floatingBadge2 = document.getElementById('floatingBadge2');
    const scrollIndicator = document.getElementById('heroScrollIndicator');
    const heroTextCol = document.getElementById('heroTextSection');
    const headerEl = document.querySelector('.blinkit-header');

    if (window.gsap && heroSection) {
        const tl = gsap.timeline({ defaults: { ease: 'power3.out' } });

        const pill = document.querySelector('.hero-pill-tag');
        if (pill) tl.from(pill, { y: -25, opacity: 0, duration: 0.5 });
        if (heroTitle) tl.from(heroTitle, { y: 30, opacity: 0, duration: 0.6 }, '-=0.3');
        if (heroDesc) tl.from(heroDesc, { y: 20, opacity: 0, duration: 0.5 }, '-=0.4');
        if (heroSearch) tl.from(heroSearch, { scale: 0.95, y: 20, opacity: 0, duration: 0.5 }, '-=0.3');
        if (heroCuisines) tl.from(heroCuisines, { opacity: 0, y: 15, duration: 0.4 }, '-=0.3');
        if (heroBadges && heroBadges.children.length > 0) {
            tl.from(heroBadges.children, { opacity: 0, y: 15, stagger: 0.08, duration: 0.4 }, '-=0.2');
        }

        if (heroCenterpiece) {
            tl.from(heroCenterpiece, { scale: 0.8, opacity: 0, rotation: -8, duration: 0.9, ease: 'back.out(1.4)' }, '-=0.8');
        }

        const floatingElements = [floatingCard1, floatingCard2, floatingBadge1, floatingBadge2].filter(Boolean);
        if (floatingElements.length > 0) {
            tl.from(floatingElements, { scale: 0.6, opacity: 0, y: 25, stagger: 0.1, duration: 0.6, ease: 'back.out(1.7)' }, '-=0.5');
        }

        if (scrollIndicator) {
            tl.from(scrollIndicator, { opacity: 0, y: 10, duration: 0.4 }, '-=0.2');
        }
    }

    // 3. Smooth Scroll-Based Parallax & Transform Engine
    // Uses a high-performance requestAnimationFrame lerp loop for buttery 60/120fps motion
    if (heroSection) {
        let currentY = window.scrollY || 0;
        let targetY = currentY;
        let isTicking = false;

        const onScroll = () => {
            targetY = Math.max(0, window.scrollY || window.pageYOffset || 0);
            if (!isTicking) {
                isTicking = true;
                requestAnimationFrame(updateParallax);
            }
        };

        const updateParallax = () => {
            // Smooth lerp interpolation
            currentY += (targetY - currentY) * 0.15;

            // Only compute when near hero viewport
            if (currentY < window.innerHeight * 1.4) {
                const y = currentY;

                // 1. Centerpiece food dish: zooms, rotates slightly & moves with parallax
                if (heroCenterpiece) {
                    const scaleVal = 1 + y * 0.0006;
                    const rotateVal = y * 0.015;
                    const translateYVal = y * 0.28;
                    const opacityVal = Math.max(0, 1 - y / 520);
                    heroCenterpiece.style.transform = `translate3d(0, ${translateYVal}px, 0) scale(${scaleVal}) rotate(${rotateVal}deg)`;
                    heroCenterpiece.style.opacity = opacityVal;
                }

                // 2. Floating Satellite Dish 1 (Top-Left: Biryani) - drifts out & up
                if (floatingCard1) {
                    const driftX = -y * 0.22;
                    const driftY = -y * 0.14;
                    const op = Math.max(0, 1 - y / 280);
                    floatingCard1.style.transform = `translate3d(${driftX}px, ${driftY}px, 0) rotate(${-y * 0.02}deg)`;
                    floatingCard1.style.opacity = op;
                }

                // 3. Floating Satellite Dish 2 (Bottom-Right: Burger) - drifts out & down
                if (floatingCard2) {
                    const driftX = y * 0.24;
                    const driftY = y * 0.26;
                    const op = Math.max(0, 1 - y / 280);
                    floatingCard2.style.transform = `translate3d(${driftX}px, ${driftY}px, 0) rotate(${y * 0.02}deg)`;
                    floatingCard2.style.opacity = op;
                }

                // 4. Floating Badges (Top-Right / Bottom-Left)
                if (floatingBadge1) {
                    const driftX = -y * 0.18;
                    const driftY = y * 0.25;
                    const op = Math.max(0, 1 - y / 220);
                    floatingBadge1.style.transform = `translate3d(${driftX}px, ${driftY}px, 0)`;
                    floatingBadge1.style.opacity = op;
                }
                if (floatingBadge2) {
                    const driftX = y * 0.18;
                    const driftY = -y * 0.18;
                    const op = Math.max(0, 1 - y / 220);
                    floatingBadge2.style.transform = `translate3d(${driftX}px, ${driftY}px, 0)`;
                    floatingBadge2.style.opacity = op;
                }

                // 5. Hero Text & Mega Search Section - moves up & fades gracefully
                if (heroTextCol) {
                    const textY = -y * 0.35;
                    const textScale = Math.max(0.92, 1 - y * 0.0003);
                    const textOp = Math.max(0, 1 - y / 340);
                    heroTextCol.style.transform = `translate3d(0, ${textY}px, 0) scale(${textScale})`;
                    heroTextCol.style.opacity = textOp;
                }

                // 6. Scroll Indicator - disappears quickly
                if (scrollIndicator) {
                    scrollIndicator.style.opacity = Math.max(0, 1 - y / 75);
                }
            }

            // 7. Sticky Header Dynamic Elevation
            if (headerEl) {
                if (currentY > 30) {
                    headerEl.classList.add('scrolled-header');
                } else {
                    headerEl.classList.remove('scrolled-header');
                }
            }

            // Continue loop while moving
            if (Math.abs(targetY - currentY) > 0.1) {
                requestAnimationFrame(updateParallax);
            } else {
                isTicking = false;
            }
        };

        window.addEventListener('scroll', onScroll, { passive: true });
        // Initial positioning
        onScroll();
    }

    // 4. Horizontal Product Carousel Buttons
    const carouselContainers = document.querySelectorAll('.carousel-container-wrap');
    carouselContainers.forEach(wrapper => {
        const row = wrapper.querySelector('.product-carousel-row');
        const btnLeft = wrapper.querySelector('.carousel-btn-left');
        const btnRight = wrapper.querySelector('.carousel-btn-right');

        if (row && btnLeft && btnRight) {
            btnLeft.addEventListener('click', () => {
                row.scrollBy({ left: -340, behavior: 'smooth' });
            });
            btnRight.addEventListener('click', () => {
                row.scrollBy({ left: 340, behavior: 'smooth' });
            });
        }
    });

    // 5. Mega Search dynamic placeholder cycler for hero
    const heroInput = document.querySelector('.hero-search-input');
    if (heroInput) {
        const cravings = ['"wood-fired pizza"', '"dum biryani"', '"crispy crunch burger"', '"cold coffee frappe"', '"red velvet cake"', '"peri-peri fries"'];
        let cravingIndex = 0;
        let charIndex = 0;
        let isDeleting = false;
        let currentCraving = cravings[0];

        const typePlaceholder = () => {
            if (document.activeElement === heroInput) {
                setTimeout(typePlaceholder, 1000);
                return;
            }

            if (!isDeleting) {
                charIndex++;
                heroInput.placeholder = `Search for ${currentCraving.substring(0, charIndex)}...`;
                if (charIndex >= currentCraving.length) {
                    isDeleting = true;
                    setTimeout(typePlaceholder, 2000);
                    return;
                }
                setTimeout(typePlaceholder, 70);
            } else {
                charIndex--;
                heroInput.placeholder = `Search for ${currentCraving.substring(0, charIndex)}...`;
                if (charIndex <= 0) {
                    isDeleting = false;
                    cravingIndex = (cravingIndex + 1) % cravings.length;
                    currentCraving = cravings[cravingIndex];
                    setTimeout(typePlaceholder, 400);
                    return;
                }
                setTimeout(typePlaceholder, 35);
            }
        };
        setTimeout(typePlaceholder, 1200);
    }
});
