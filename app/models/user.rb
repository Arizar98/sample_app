class User < ApplicationRecord

  before_save{email.downcase!}

  validates :name, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255}, format: {with: VALID_EMAIL_REGEX}

  has_secure_password

  def User.digest string
  cost = if ActiveModel::SecurePassword.min_cost
      BCrypt::Engine::MIN_COST
    else
      BCrypt::Engine.cost
    end
  BCrypt::Password.create string, cost: cost
  end
end
