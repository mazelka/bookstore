class Customer < ApplicationRecord
  has_many :reviews
  before_validation :downcase_email
  before_save :downcase_email
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  validates :first_name, presence: true, length: { maximum: 50 }, format: { with: /[a-zA-Z]/ }
  validates :last_name, presence: true, length: { maximum: 50 }, format: { with: /[a-zA-Z]/ }
  validates :email, presence: true, uniqueness: true, length: { maximum: 63 }, format: { with: VALID_EMAIL_REGEX }
  # validates :check_password_format, presence: true

  private

  # def check_password_format
  #   regexps = { 'must contain at least one lowercase letter' => /[a-z]+/,
  #              'must contain at least one uppercase letter' => /[A-Z]+/,
  #              'must contain at least one digit' => /\d+/,
  #              'must not contain spaces' => /\s/ }
  #   regexps.each do |rule, reg|
  #     errors.add(:password, rule) unless password.match(reg)
  #   end
  # end

  # def trim_password
  #   password.strip!
  # end

  def downcase_email
    email.downcase!
  end
end
