(function () {
  const navButton = document.getElementById("nav-button");
  navButton.addEventListener("click", () => {
    document.getElementById("nav-menu").classList.toggle("inactive");
  });
})();
