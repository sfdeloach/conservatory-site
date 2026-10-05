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

const user = "mconservatory";
const domain = "sachapel.com";
const element = document.getElementById("footer-contact-info").innerHTML;
document.getElementById("footer-contact-info").innerHTML =
  element +
  '<a href="mailto:' +
  user +
  "@" +
  domain +
  '">' +
  user +
  "@" +
  domain +
  "</a>";
