module CartsHelper
  def checkout_style(cart)
    if cart && cart.size.positive?
      'btn btn-default mb-20 hidden-xs center-block check-center'
    else
      'btn btn-default mb-20 hidden-xs center-block check-center disabled'
    end
  end
end
