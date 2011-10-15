class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  has_many :plans
  attr_accessible :email, :password, :password_confirmation, :remember_me
end
