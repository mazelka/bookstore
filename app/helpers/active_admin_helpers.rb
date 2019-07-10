module ActiveAdminHelpers
  def customize_status_tag(state)
    if state == 'approved'
      'approved_tag'
    elsif state == 'rejected'
      'rejected_tag'
    else
      'unprocessed_tag'
    end
  end

  def customize_payment_tag(payment)
    if payment == 'PAID'
      'paid'
    else
      'unpaid'
    end
  end

  def order_items_details(order)
    result = ''
    order.order_items.each do |item|
      result.concat("Book title: #{item.book.title}, price: #{Money.new(item.book.price).format}, quantity: #{item.quantity} ")
    end
    result
  end
end
