class User < ActiveRecord::Base
  include Amistad::FriendModel
  include Gravtastic
  gravtastic
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  geocoded_by :location
  has_many :participants
  has_many :plans, :through => :participants
  attr_accessible :name, :password, :password_confirmation, :latitude, :longitude, :location, :email, :remember_me
  validates_uniqueness_of :email
  validates_presence_of :name
  after_validation :geocode

  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    data = access_token['extra']['user_hash']
    if user = User.find_by_email(data['email'])
      user
    else
      user = User.create!(:email => data['email'], :name => data['name'], :password => SecureRandom.hex(8))
    end
  end
end