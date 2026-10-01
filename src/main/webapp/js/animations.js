/**
 * Blinkit GSAP & AOS Animations Setup
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

    // 2. GSAP Hero Banner Stagger
    if (window.gsap) {
        const heroTag = document.querySelector('.hero-pill-tag');
        const heroHeading = document.querySelector('.hero-heading');
        const heroSubtitle = document.querySelector('.hero-subtitle');
        const heroBadges = document.querySelectorAll('.feature-badge-item');
        const heroImg = document.querySelector('.hero-image-wrap img');

        if (heroHeading) {
            const tl = gsap.timeline({ defaults: { ease: 'power3.out' } });
            if (heroTag) tl.from(heroTag, { y: -20, opacity: 0, duration: 0.4 });
            tl.from(heroHeading, { y: 20, opacity: 0, duration: 0.5 }, '-=0.2');
            if (heroSubtitle) tl.from(heroSubtitle, { y: 20, opacity: 0, duration: 0.4 }, '-=0.3');
            if (heroBadges.length > 0) {
                tl.from(heroBadges, { y: 15, opacity: 0, stagger: 0.1, duration: 0.4 }, '-=0.2');
            }
            if (heroImg) {
                tl.from(heroImg, { scale: 0.85, opacity: 0, duration: 0.6 }, '-=0.5');
            }
        }
    }

    // 3. Carousel Horizontal Scroll Buttons
    const carouselContainers = document.querySelectorAll('.carousel-container-wrap');
    carouselContainers.forEach(wrapper => {
        const row = wrapper.querySelector('.product-carousel-row');
        const btnLeft = wrapper.querySelector('.carousel-btn-left');
        const btnRight = wrapper.querySelector('.carousel-btn-right');

        if (row && btnLeft && btnRight) {
            btnLeft.addEventListener('click', () => {
                row.scrollBy({ left: -320, behavior: 'smooth' });
            });
            btnRight.addEventListener('click', () => {
                row.scrollBy({ left: 320, behavior: 'smooth' });
            });
        }
    });
});
