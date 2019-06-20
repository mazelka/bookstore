class Customer < ApplicationRecord
  has_many :reviews
  before_save :downcase_email, :trim_password
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, omniauth_providers: %i[facebook]

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  validates :first_name, presence: true, length: { maximum: 50 }, format: { with: /[a-zA-Z]/ }
  validates :last_name, presence: true, length: { maximum: 50 }, format: { with: /[a-zA-Z]/ }
  validates :email, presence: true, uniqueness: true, length: { maximum: 63 }, format: { with: VALID_EMAIL_REGEX }
  validate :check_password_format

  private

  def check_password_format
    regexps = { 'must contain at least one lowercase letter' => /[a-z]+/,
               'must contain at least one uppercase letter' => /[A-Z]+/,
               'must contain at least one digit' => /\d+/ }
    unless password.nil?
      regexps.each do |rule, reg|
        errors.add(:password, rule) unless password.match(reg)
      end
      errors.add(:password, 'must not contain spaces') if password.match(/\s/)
    end
  end

  def trim_password
    password.strip!
  end

  def downcase_email
    email.downcase!
  end
end
