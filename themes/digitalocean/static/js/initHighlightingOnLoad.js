function initHighlighting() {
  // Turn off automatic language detection
  // https://github.com/isagalaev/highlight.js/issues/415#issuecomment-35975968
	hljs.configure({ languages: [] });
	hljs.initHighlighting();
};

$(initHighlighting);
