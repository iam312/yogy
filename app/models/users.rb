class Users < ActiveRecord::Base
  validates :email, presence: true
end
