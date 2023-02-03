module.exports = {
  root: true,
  env: {
    es2017: true,
    node: true,
  },
  extends: [
    "eslint:recommended",
    "google",
  ],
  rules: {
    "quotes": ["error", "double"],
    "linebreak-style": 0,
  },
};
