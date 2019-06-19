require 'rails_helper'

describe 'Category', type: :feature do
  let(:category) { create(:category) }
  before :each do
    category
    sign_in
  end

  it 'visits categories page' do
    visit '/admin/categories'
    expect(page).to have_content('Categories')
    expect(page).to have_selector('#filters_sidebar_section')
    expect(page).to have_selector('#index_table_categories')
  end

  it 'creates new category' do
    visit '/admin/categories/new'
    within('.inputs') do
      find('#category_title').set('Drama')
    end
    click_button 'Create Category'
    expect(page).to have_content('Category was successfully created.')
  end

  it 'edits existed category' do
    visit 'admin/categories'
    search_by_title(category.title)
    click_link 'Edit'
    within('.inputs') do
      find('#category_title').set('Comedy')
    end
    click_button 'Update Category'
    expect(page).to have_content('Category was successfully updated.')
    expect(page).to have_content('Comedy')
  end

  it 'deletes category' do
    visit 'admin/categories'
    categories_before_delete = page.all('#index_table_categories tbody tr').length
    search_by_title(category.title)
    click_link 'Delete'
    categories_after_delete = page.all('#index_table_categories tbody tr').length
    expect(categories_after_delete).to eq(categories_before_delete - 1)
    expect(page).to have_content('Category was successfully destroyed.')
  end
end
