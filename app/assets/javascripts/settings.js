$(document).ready(function() {
  $(".agree-remove").click(function(e) {
    if (e.target.checked) {
      $(".remove-customer").prop("disabled", false);
    } else {
      $(".remove-customer").prop("disabled", true);
    }
  });
});
