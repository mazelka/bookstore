require 'rails_helper'

describe 'Review', type: :feature do
  context 'view' do
    let(:review) { create(:review) }
    before :each do
      review
      sign_in
    end

    it 'visits reviews page' do
      visit '/admin/reviews'
      expect(page).to have_content('Reviews')
      expect(page).to have_selector('#filters_sidebar_section')
      expect(page).to have_selector('#index_table_reviews')
    end

    it 'opens existed review' do
      visit '/admin/reviews'
      search_by_title(review.title)
      click_link 'View'
      expect(page).to have_content(review.title)
      expect(page).to have_no_link(review.text)
      expect(page).to have_content(review.aasm_state)
      expect(page).to have_no_link('Edit')
    end

    it 'cannot create new review' do
      visit '/admin/reviews'
      expect(page).to have_content('Reviews')
      expect(page).to have_no_link('Delete')
      expect(page).to have_no_link('Edit')
      expect(page).to have_no_link('New Review')
    end
  end

  context 'when unprocessed review' do
    let(:review) { create(:review) }
    before :each do
      review
      sign_in
    end

    it 'has Approve and Reject button' do
      visit '/admin/reviews'
      search_by_title(review.title)
      click_link 'View'
      expect(page).to have_link('Approve')
      expect(page).to have_link('Reject')
    end
  end

  context 'change status' do
    let(:review) { create(:review) }
    before :each do
      review
      sign_in
    end

    it 'approves unprocessed review' do
      visit '/admin/reviews'
      search_by_title(review.title)
      click_link 'View'
      click_link 'Approve'
      expect(page).to have_content('Review has been approved!')
      expect(page).to have_no_link('Approve')
      expect(page).to have_no_link('Reject')
    end

    it 'rejects unprocessed review' do
      visit '/admin/reviews'
      search_by_title(review.title)
      click_link 'View'
      click_link 'Reject'
      expect(page).to have_content('Review has been rejected!')
      expect(page).to have_no_link('Approve')
      expect(page).to have_no_link('Reject')
    end
  end

  context 'scopes' do
    let(:approved_review) { create(:review, aasm_state: 'approved') }
    let(:rejected_review) { create(:review, aasm_state: 'rejected') }
    let(:unprocessed_review) { create(:review) }
    before :each do
      approved_review
      rejected_review
      unprocessed_review
      sign_in
    end

    it 'contain unprocessed reviews' do
      visit '/admin/reviews?scope=unprocessed'
      expect(page).to have_content(unprocessed_review.title)
      expect(page).to have_no_content(approved_review.title)
      expect(page).to have_no_content(rejected_review.title)
    end

    it 'contain approved reviews' do
      visit '/admin/reviews?scope=approved'
      expect(page).to have_content(approved_review.title)
      expect(page).to have_no_content(unprocessed_review.title)
      expect(page).to have_no_content(rejected_review.title)
    end

    it 'contain rejected reviews' do
      visit '/admin/reviews?scope=rejected'
      expect(page).to have_content(rejected_review.title)
      expect(page).to have_no_content(approved_review.title)
      expect(page).to have_no_content(unprocessed_review.title)
    end

    context 'after changing status' do
      it 'shown in Approved after approve' do
        visit '/admin/reviews?scope=unprocessed'
        search_by_title(unprocessed_review.title)
        click_link 'View'
        click_link 'Approve'
        visit '/admin/reviews?scope=unprocessed'
        expect(page).to have_no_content(unprocessed_review.title)
        visit '/admin/reviews?scope=approved'
        expect(page).to have_content(unprocessed_review.title)
      end

      it 'shown in Rejected after reject' do
        visit '/admin/reviews?scope=unprocessed'
        search_by_title(unprocessed_review.title)
        click_link 'View'
        click_link 'Reject'
        visit '/admin/reviews?scope=unprocessed'
        expect(page).to have_no_content(unprocessed_review.title)
        visit '/admin/reviews?scope=rejected'
        expect(page).to have_content(unprocessed_review.title)
      end
    end
  end
end
