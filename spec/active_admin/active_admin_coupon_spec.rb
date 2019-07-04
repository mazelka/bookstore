require 'rails_helper'

describe 'Coupon', type: :feature do
  let(:coupon) { create(:coupon) }
  before :each do
    coupon
    sign_in
  end

  it 'visits coupons page' do
    visit '/admin/coupons'
    expect(page).to have_content('Coupons')
    expect(page).to have_selector('#filters_sidebar_section')
    expect(page).to have_selector('#index_table_coupons')
  end

  it 'creates new coupon' do
    visit '/admin/coupons/new'
    within('.inputs') do
      find('#coupon_name').set('SALE')
      find('#coupon_discount').set(100)
    end
    click_button 'Create Coupon'
    expect(page).to have_content('Coupon was successfully created.')
  end

  it 'edits existed coupon' do
    visit 'admin/coupons'
    search_by_name(coupon.name)
    click_link 'Edit'
    within('.inputs') do
      find('#coupon_name').set('NEWYEAR')
      find('#coupon_discount').set(100)
    end
    click_button 'Update Coupon'
    expect(page).to have_content('Coupon was successfully updated.')
    expect(page).to have_content('NEWYEAR')
  end

  it 'deletes coupon' do
    visit 'admin/coupons'
    coupons_before_delete = page.all('#index_table_coupons tbody tr').length
    search_by_name(coupon.name)
    click_link 'Delete'
    coupons_after_delete = page.all('#index_table_coupons tbody tr').length
    expect(coupons_after_delete).to eq(coupons_before_delete - 1)
    expect(page).to have_content('Coupon was successfully destroyed.')
  end
end
