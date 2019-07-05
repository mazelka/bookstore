module CheckoutHelper
  def fill_if_complete(step)
    if current_step?(step)
      'step active'
    else
      'step'
    end
  end
end
