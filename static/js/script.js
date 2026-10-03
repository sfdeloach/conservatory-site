(function () {
  const navButton = document.getElementById("nav-button");
  navButton.addEventListener("click", () => {
    document.getElementById("nav-menu").classList.toggle("inactive");
    document.getElementById("nav-button-menu").classList.toggle("button-hide");
    document.getElementById("nav-button-close").classList.toggle("button-hide");
  });
})();
