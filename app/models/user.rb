class User < ApplicationRecord
  # Auth stuff
  has_secure_password
  has_many :sessions, dependent: :destroy
  normalizes :email_address, with: ->(e) { e.strip.downcase }

  # Other associations
  has_many :leagues, dependent: :destroy
end
