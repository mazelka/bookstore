class AddAasmToReview < ActiveRecord::Migration[5.2]
  def change
    add_column :reviews, :aasm_state, :string
  end
end
