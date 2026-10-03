const navButton = document.getElementById("nav-button");

navButton.addEventListener("click", () => {
  const expanded = navButton.getAttribute("aria-expanded") === "true";
  navButton.setAttribute("aria-expanded", !expanded);
});

document.addEventListener("keydown", (event) => {
  console.log(event.key);
  if (event.key === "Escape") {
    navButton.setAttribute("aria-expanded", "false");
  }
});
