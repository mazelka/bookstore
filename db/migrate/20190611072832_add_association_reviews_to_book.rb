class AddAssociationReviewsToBook < ActiveRecord::Migration[5.2]
  def change
    change_table :books do |t|
      t.references :review, foreign_key: true
    end
  end
end
