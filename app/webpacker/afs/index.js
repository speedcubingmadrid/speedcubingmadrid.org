// Setup all tooltips
$(document).on('turbolinks:load', function() {
  $('[data-toggle="tooltip"]').tooltip();
  $(".sort-me").tablesorter();
})

window.ams = window.ams || {};

window.ams.computeSlug = function(title) {
  let normalized = title.normalize('NFD').replace(/[\u0300-\u036f]/g, "");
  normalized = normalized.replace(/['"]/g, "");
  normalized = normalized.replace(/ /g, "-");
  normalized = normalized.toLowerCase();
  return normalized;
}
