document.addEventListener("DOMContentLoaded", function () {
    // APIのエンドポイント（適宜変更してください）
    var apiUrl = 'https://api.laamile.com/api/email';

    // メールアドレスを表示するHTML要素を取得
    var element = document.getElementById("email");

    // APIからデータを取得する
    fetch(apiUrl)
        .then(response => {
            // レスポンスをテキスト形式で取得
            return response.text();
        })
        .then(email => {
            // メールアドレスをHTML要素に挿入
            element.innerHTML = '<i class="fas fa-envelope"></i> ' + email;
        })
        .catch(error => {
            console.error('Error fetching email:', error);
            element.innerHTML = '<i class="fas fa-envelope"></i> Error loading email';
        });
});
