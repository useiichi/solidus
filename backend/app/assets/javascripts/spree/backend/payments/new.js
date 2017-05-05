//= require jquery.payment
$(document).ready(function() {
  if ($("#new_payment").is("*")) {
    $(".cardNumber").payment('formatCardNumber');
    $(".cardExpiry").payment('formatCardExpiry');
    $(".cardCode").payment('formatCardCVC');

    $(".cardNumber").change(function() {
      $(".ccType").val($.payment.cardType(this.value))
    })

    $('.payment_methods_radios').click(
      function() {
        $('.payment-methods').hide();
        $('.payment-methods :input').prop('disabled', true);
        if (this.checked) {
          $('#payment_method_' + this.value + ' :input').prop('disabled', false);
          $('#payment_method_' + this.value).show();
        }
      }
    );

    $('.payment_methods_radios').each(
      function() {
        if (this.checked) {
          $('#payment_method_' + this.value + ' :input').prop('disabled', false);
          $('#payment_method_' + this.value).show();
        } else {
          $('#payment_method_' + this.value).hide();
          $('#payment_method_' + this.value + ' :input').prop('disabled', true);
        }

        if ($("#card_new" + this.value).is("*")) {
          $("#card_new" + this.value).radioControlsVisibilityOfElement('#card_form' + this.value);
        }
      }
    );
  }
});
