document.addEventListener("DOMContentLoaded", function () {
    var user = "ishii-kanade";
    var domain = "laamile.com";
    var element = document.getElementById("email");
    element.innerHTML =
        '<i class="fas fa-envelope"></i> ' + user + "@" + domain;
});

document.getElementById('passwordInput').addEventListener('input', function (event) {
    var passwordInput = event.target;
    var password = passwordInput.value;
    if (password.length === 8) {  // パスワードが8文字になった時にリクエストを送信
        fetch('https://api.laamile.com/api/password', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ password: password })
        })
            .then(function (response) {
                if (response.ok) {
                    return response.json();
                } else {
                    throw new Error('サーバーからエラーが返されました。');
                }
            })
            .then(function (data) {
                // URLが返されたら、そこにリダイレクト
                window.location.href = data.url;
            })
            .catch(function (error) {
                console.error('Error:', error);
                alert(error.message); // ブラウザのアラートでエラーメッセージを表示
                passwordInput.value = ''; // パスワード入力欄を空にする
                passwordInput.classList.add('is-invalid'); // 入力欄を赤くする
            });
    } else {
        passwordInput.classList.remove('is-invalid'); // パスワード長が8未満のときは赤い枠を削除
    }
});










