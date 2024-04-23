document.getElementById('passwordInput').addEventListener('input', function() {
    var correctPassword = '19981225';
    var input = this.value;
    var lengthToCheck = Math.min(input.length, correctPassword.length);  // 入力または正しいパスワードの短い方の長さ
    var correctCount = 0;

    for (var i = 0; i < lengthToCheck; i++) {
        if (input[i] === correctPassword[i]) correctCount++;
    }

    var maxBlur = 10;  // 最大ぼかし効果
    var blur = maxBlur * (1 - correctCount / correctPassword.length);  // 一致する割合に基づいてぼかしを減らす

    document.getElementById('contactInfo').style.filter = `blur(${blur}px)`;
});




