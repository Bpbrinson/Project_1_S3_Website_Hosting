// Mobile menu toggle
const menuBtn = document.getElementById("menuToggle");
const nav = document.getElementById("nav");

if (menuBtn && nav) {
  menuBtn.addEventListener("click", () => {
    nav.classList.toggle("open");
  });
}

// Theme toggle (light/dark) with persistence
const themeToggle = document.getElementById("themeToggle");
const root = document.documentElement;

const savedTheme = localStorage.getItem("theme");
if (savedTheme) {
  root.setAttribute("data-theme", savedTheme);
}

if (themeToggle) {
  themeToggle.addEventListener("click", () => {
    const current = root.getAttribute("data-theme") || "dark";
    const next = current === "dark" ? "light" : "dark";
    root.setAttribute("data-theme", next);
    localStorage.setItem("theme", next);
  });
}

// Fake submit for demo
function fakeSubmit() {
  const s = document.getElementById("formStatus");
  if (s) s.textContent = "Thanks! This demo form doesn't send messages yet.";
}
window.fakeSubmit = fakeSubmit;

// Contact form submit (optional real backend)
const form = document.getElementById("contactForm");
const statusEl = document.getElementById("formStatus");

// For S3 static hosting, set this in index.html as:
// window.CONTACT_API_URL = "https://YOUR_API_ID.execute-api.us-east-1.amazonaws.com/contact";
const API_URL = window.CONTACT_API_URL || "";

if (form && statusEl) {
  form.addEventListener("submit", async (e) => {
    e.preventDefault();
    statusEl.textContent = "Sending...";

    const payload = Object.fromEntries(new FormData(form).entries());

    try {
      if (!API_URL) {
        statusEl.textContent = "Demo mode: no backend configured.";
        return;
      }

      const res = await fetch(API_URL, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(payload),
      });

      const data = await res.json().catch(() => ({}));
      if (!res.ok) throw new Error(data.error || "Failed");

      statusEl.textContent = "Message sent ✅";
      form.reset();
    } catch (err) {
      statusEl.textContent = "Error sending message ❌";
      console.error(err);
    }
  });
}