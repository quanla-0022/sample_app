//= require jquery
//= require i18n.js
//= require i18n/translations

$(document).ready(() => {
  $("#micropost_picture").bind("change", function() {
    var size_in_megabytes = this.files[0].size/1024/1024;
    if (size_in_megabytes > 5) {
      alert(I18n.t("image_too_large"));
    }
  });
});
