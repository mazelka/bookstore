$(document).ready(function() {
  $(".agree-remove").click(function(e) {
    if (e.target.checked) {
      $(".remove-customer").prop("disabled", false);
    } else {
      $(".remove-customer").prop("disabled", true);
    }
  });
  $('[name="billing"]').click(function(e) {
    if (e.target.checked) {
      $(".billing-section").hide();
    } else {
      $(".billing-section").show();
    }
  });
  $(".submit-address").submit(function(e) {
    if ($('[name="billing"]').prop("checked")) {
      $("#customer_billing_address_attributes_address_line").val(
        $("#customer_shipping_address_attributes_address_line").val()
      );
      $("#customer_billing_address_attributes_city").val(
        $("#customer_shipping_address_attributes_city").val()
      );
      $("#customer_billing_address_attributes_country").val(
        $("#customer_shipping_address_attributes_country").val()
      );
      $("#customer_billing_address_attributes_zip").val(
        $("#customer_shipping_address_attributes_zip").val()
      );
      $("#customer_billing_address_attributes_phone").val(
        $("#customer_shipping_address_attributes_phone").val()
      );
    }
  });
});
