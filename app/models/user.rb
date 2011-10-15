class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  has_and_belongs_to_many :plans
  attr_accessible :email, :password, :password_confirmation, :remember_me
  validates_uniqueness_of :email

  def initialize (options = {})
    super
    self.mobile_key = SecureRandom.hex(16)
  end

  def generate_mobile_key!
    update_attribute :mobile_key, SecureRandom.hex(16)
  end
end
