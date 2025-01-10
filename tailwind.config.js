/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./_site/**/*.html", // Jekyllの生成済みHTMLファイルを指定
    "./_includes/**/*.html",
    "./_layouts/**/*.html",
    "./*.html",
  ],
  theme: {
    extend: {},
  },
  plugins: [require("@tailwindcss/typography")],
};
