class Customer < ApplicationRecord
  has_many :reviews
  before_save :downcase_email, on: [:create, :update]
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  validates :first_name, presence: true, length: { maximum: 50 }, format: { with: /[a-zA-Z]/ }
  validates :last_name, presence: true, length: { maximum: 50 }, format: { with: /[a-zA-Z]/ }
  validates :email, presence: true, uniqueness: true, length: { maximum: 63 }, format: { with: VALID_EMAIL_REGEX }

  private

  def downcase_email
    email.downcase!
  end
end
