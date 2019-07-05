$(document).ready(function() {
  $('[name="billing"]').click(function(e) {
    if (e.target.checked) {
      $(".billing-section").hide();
    } else {
      $(".billing-section").show();
    }
  });
});
