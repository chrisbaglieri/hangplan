class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, 
    :trackable, :validatable, :omniauthable
  has_and_belongs_to_many :plans
  attr_accessible :email, :password, :password_confirmation, :remember_me
  validates_uniqueness_of :email

  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    data = access_token['extra']['user_hash']
    if user = User.find_by_email(data['email'])
      user
    else
      User.create(:email => data['email'], :password => Devise.friendly_token[0-20])
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["user_hash"]
        user.email = data["email"]
      end
    end
  end

  def initialize(options = {})
    super
    self.mobile_key = SecureRandom.hex(16)
  end

  def generate_mobile_key!
    update_attribute :mobile_key, SecureRandom.hex(16)
  end
  
end
