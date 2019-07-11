$(document).ready(function() {
  $('[name="billing"]').click(function(e) {
    if (e.target.checked) {
      $(".billing-section").hide();
    } else {
      $(".billing-section").show();
    }
  });
});

$(document).ready(function() {
  $(".submit-address").submit(function(e) {
    if ($('[name="billing"]').prop("checked")) {
      console.log(1);
      $("#billing_address_attributes_address_line").val(
        $("#shipping_address_attributes_address_line").val()
      );
      $("#billing_address_attributes_city").val(
        $("#shipping_address_attributes_city").val()
      );
      $("#billing_address_attributes_country").val(
        $("#shipping_address_attributes_country").val()
      );
      $("#billing_address_attributes_zip").val(
        $("#shipping_address_attributes_zip").val()
      );
      $("#billing_address_attributes_phone").val(
        $("#shipping_address_attributes_phone").val()
      );
    }
  });
});
