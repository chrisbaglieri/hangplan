class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  has_and_belongs_to_many :plans
  attr_accessible :email, :password, :password_confirmation, :remember_me
end
