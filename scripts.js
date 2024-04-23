// scripts.js
document.addEventListener("DOMContentLoaded", function () {
    var user = "ishii-kanade";
    var domain = "laamile.com";
    var element = document.getElementById("email");
    element.innerHTML = '<i class="fas fa-envelope"></i> ' + user + "@" + domain;
});

function checkPassword() {
    var password = document.getElementById("passwordInput").value;
    if (password === "19981225") {
        window.location.href = "https://line.me/R/ti/p/XK-Z_Y4dxT";
    }
}
