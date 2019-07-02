class Order < ApplicationRecord
  include AASM

  has_many :order_items
  has_one :delivery
  belongs_to :customer
  has_many :addresses, as: :addressable
  accepts_nested_attributes_for :addresses

  scope :in_progress, -> { where(aasm_state: [:in_progress, :in_queue, :in_delivery]) }
  scope :delivered, -> { where(aasm_state: :delivered) }
  scope :canceled, -> { where(aasm_state: :canceled) }

  aasm do
    state :in_progress, initial: true
    state :in_queue
    state :in_delivery
    state :delivered
    state :canceled

    event :start_processing do
      transitions from: :in_progress, to: :in_queue
    end

    event :start_delivery do
      transitions from: :in_progress, to: :in_delivery
    end

    event :finish_delivery do
      transitions from: :in_delivery, to: :delivered
    end

    event :cancel do
      transitions from: [:in_progress, :in_progress, :in_delivery, :delivered], to: :canceled
    end
  end

  validates :total_price, presence: true
end
