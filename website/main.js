// Year
document.getElementById('yr').textContent = new Date().getFullYear();

// Contact form — replace API_GATEWAY_URL with your real endpoint
const API_GATEWAY_URL = 'YOUR_API_GATEWAY_URL_HERE';

async function submitForm(e) {
  e.preventDefault();
  const btn = document.getElementById('submitBtn');
  const status = document.getElementById('formStatus');
  const name = document.getElementById('cf-name').value;
  const email = document.getElementById('cf-email').value;
  const message = document.getElementById('cf-msg').value;

  btn.textContent = 'Sending...';
  btn.disabled = true;
  status.style.display = 'none';

  try {
    const res = await fetch(API_GATEWAY_URL, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ name, email, message })
    });
    if (res.ok) {
      status.textContent = '✓ Message sent! I will get back to you soon.';
      status.className = 'form-status success';
      document.getElementById('contactForm').reset();
    } else {
      throw new Error('Server error');
    }
  } catch {
    status.textContent = '✗ Something went wrong. Please email me directly.';
    status.className = 'form-status error';
  }

  status.style.display = 'block';
  btn.textContent = 'Send Message';
  btn.disabled = false;
}

// Smooth scroll for all anchor links
document.querySelectorAll('a[href^="#"]').forEach(a => {
  a.addEventListener('click', e => {
    const target = document.querySelector(a.getAttribute('href'));
    if (target) { e.preventDefault(); target.scrollIntoView({ behavior: 'smooth' }); }
    document.querySelector('.nav-links').classList.remove('open');
  });
});

// Fade-in on scroll
const observer = new IntersectionObserver(entries => {
  entries.forEach(entry => {
    if (entry.isIntersecting) {
      entry.target.style.opacity = '1';
      entry.target.style.transform = 'translateY(0)';
      observer.unobserve(entry.target);
    }
  });
}, { threshold: 0.1 });

document.querySelectorAll('.stat-card, .project-card, .tl-card, .skill-card, .cert-card').forEach(el => {
  el.style.opacity = '0';
  el.style.transform = 'translateY(20px)';
  el.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
  observer.observe(el);
});
