class Customer < ApplicationRecord
  has_many :reviews
  before_save :downcase_email, on: [:create, :update]
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: %i[facebook]

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  validates :first_name, presence: true, length: { maximum: 50 }, format: { with: /[a-zA-Z]/ }
  validates :last_name, presence: true, length: { maximum: 50 }, format: { with: /[a-zA-Z]/ }
  validates :email, presence: true, uniqueness: true, length: { maximum: 63 }, format: { with: VALID_EMAIL_REGEX }
  validate :check_password_format

  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_create do |customer|
      customer.provider = auth.provider
      customer.uid = auth.uid
      auth.info.email.present? and customer.email = auth.info.email
      customer.first_name = auth.info.name.split(' ').first
      customer.last_name = auth.info.name.split(' ').last
    end
  end

  def self.new_with_session(params, session)
    if session['devise.customer_attributes']
      new(session['devise.customer_attributes']) do |customer|
        customer.attributes = params
        customer.valid?
      end
    else
      super
    end
  end

  def password_required?
    super && provider.blank?
  end

  def update_with_password(params, *options)
    if encrypted_password.blank?
      update_attributes(params, *options)
    else
      super
    end
  end

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
    password.strip! if password
  end

  def downcase_email
    email.downcase!
  end
end
