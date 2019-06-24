class Review < ApplicationRecord
  include AASM

  scope :unprocessed, -> { where(aasm_state: :unprocessed) }
  scope :approved, -> { where(aasm_state: :approved) }
  scope :rejected, -> { where(aasm_state: :rejected) }

  aasm do
    state :unprocessed, initial: true
    state :approved
    state :rejected

    event :approve do
      transitions from: :unprocessed, to: :approved
    end

    event :reject do
      transitions from: :unprocessed, to: :rejected
    end
  end

  belongs_to :book
  belongs_to :customer
  VALID_STRING_REGEX = /[a-zA-Z0-9!#$%&'*+-\/=?^_`{|}~]/

  validates :title, presence: true, length: { minimum: 1, maximum: 80 }, format: { with: VALID_STRING_REGEX }
  validates :text, presence: true, length: { minimum: 1, maximum: 500 }, format: { with: VALID_STRING_REGEX }
end
