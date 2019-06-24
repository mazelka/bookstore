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
end
