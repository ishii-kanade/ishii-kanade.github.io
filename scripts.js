document.addEventListener("DOMContentLoaded", function () {
    var user = "ishii-kanade";
    var domain = "laamile.com";
    var element = document.getElementById("email");
    element.innerHTML =
        '<i class="fas fa-envelope"></i> ' + user + "@" + domain;
});

document.getElementById('passwordForm').addEventListener('submit', function(event) {
    event.preventDefault(); // フォームのデフォルト送信を防ぐ
    var password = document.getElementById('passwordInput').value;
    fetch('https://api.laamile.com/api/password', { // URLを修正
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({password: password})
    }).then(function(response) {
        if (response.ok) {
            return response.json();
        } else {
            throw new Error('サーバーからエラーが返されました。');
        }
    }).then(function(data) {
        // URLが返されたら、そこにリダイレクト
        window.location.href = data.url;
    }).catch(function(error) {
        console.error('Error:', error);
        alert(error); // エラーをアラート表示
    });
});






