import {} from "selectize";

window.afs = window.afs || {};

window.afs.enableSelectize = function(tag_options) {
  $(".enable-selectize").each(function() {
    $(this).selectize({
      plugins: ['remove_button'],
      delimiter: ',',
      persist: false,
      options: tag_options,
      create: function(input) {
        return {
          value: input,
          text: input
        };
      },
    });
    $(this).removeClass("enable-selectize");
  });
}
