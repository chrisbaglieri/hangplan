class User < ActiveRecord::Base
  include Amistad::FriendModel
  include Gravtastic
  
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  gravtastic
  geocoded_by :location
  
  has_many :identities
  has_many :participants
  has_many :plans, :through => :participants
  validates_uniqueness_of :email
  validates_presence_of :name
  after_validation :geocode
  attr_accessible :name, :location, :email, :password, :password_confirmation, :remember_me

  def profile_image_url
    self.gravatar_url(:size => 45)
  end
end