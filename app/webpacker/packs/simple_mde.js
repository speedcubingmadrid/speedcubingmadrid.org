import SimpleMDE from "simplemde";
$(".enable-simplemde").each(function() {
  // By default SimpleMDE loads itself on the first textarea, which is what we want.
  new SimpleMDE({ element: this, spellChecker: false });
  // Prevent the turbolink reload from enabling twice simplemde on the same element.
  $(this).removeClass("enable-simplemde");
});
