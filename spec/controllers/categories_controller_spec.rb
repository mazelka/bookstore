require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  context 'show' do
    let(:category) { create(:category) }
    let(:book) { create(:book, category: category) }
    let(:book) { create(:book) }
    before :each do
      book
      category
      allow(Book).to receive(:find).and_return book
    end

    it 'renders books/index template' do
      get :show, params: { id: category.id }
      expect(response).to render_template 'books/index'
    end

    it 'has default sorting' do
      get :show, params: { id: category.id }
      expect(assigns(:active_sorting)).to eq('Newest first')
    end

    it 'has book count' do
      get :show, params: { id: category.id }
      expect(assigns(:all_books)).to eq(1)
    end

    it 'has popular categories' do
      pop_category = Category.all.sort { |b, a| a.books.count <=> b.books.count }
      get :show, params: { id: category.id }
      expect(assigns(:popular_categories)).to match_array(pop_category)
    end
  end
end
