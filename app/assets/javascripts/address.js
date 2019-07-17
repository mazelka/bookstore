$(document).ready(function() {
  $('[name="billing"]').click(function(e) {
    if (e.target.checked) {
      $(".billing-section").hide();
    } else {
      $(".billing-section").show();
    }
  });
  $(".submit-address").submit(function(e) {
    if ($('[name="billing"]').prop("checked")) {
      $("#order_billing_address_attributes_address_line").val(
        $("#order_shipping_address_attributes_address_line").val()
      );
      $("#order_billing_address_attributes_city").val(
        $("#order_shipping_address_attributes_city").val()
      );
      $("#order_billing_address_attributes_country").val(
        $("#order_shipping_address_attributes_country").val()
      );
      $("#order_billing_address_attributes_zip").val(
        $("#order_shipping_address_attributes_zip").val()
      );
      $("#order_billing_address_attributes_phone").val(
        $("#order_shipping_address_attributes_phone").val()
      );
    }
  });
});
