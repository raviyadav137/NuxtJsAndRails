# app/models/user.rb
# app/models/user.rb
class User < ApplicationRecord
  Rails.logger.debug "Loading User model and bcrypt"

  has_secure_password

  validates :first_name, :last_name, :email, :phone, :dob, presence: true
  validates :email, uniqueness: true
end

