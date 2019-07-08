module CheckoutHelper
  def fill_if_complete(step)
    if current_step?(step)
      'step active'
    else
      'step'
    end
  end

  def last_digits(number)
    number.to_s.length <= 4 ? number : number.to_s.slice(-4..-1)
  end

  def mask(number)
    "************#{last_digits(number)}"
  end
end
