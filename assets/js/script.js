const navButton = document.getElementById("nav-button");

navButton.addEventListener("click", () => {
  const isExpanded = navButton.getAttribute("aria-expanded") === "true";
  navButton.setAttribute("aria-expanded", String(!isExpanded));
});

document.addEventListener("keydown", (event) => {
  const isExpanded = navButton.getAttribute("aria-expanded") === "true";
  if (isExpanded && event.key === "Escape") {
    navButton.focus();
    navButton.setAttribute("aria-expanded", "false");
  }
});

// Close the menu when focus moves outside the header (for example, tabbing
// past the last link), so it never lands on the page hidden behind the menu.
navButton.closest("header").addEventListener("focusout", (event) => {
  const next = event.relatedTarget;
  if (next && !event.currentTarget.contains(next)) {
    navButton.setAttribute("aria-expanded", "false");
  }
});
