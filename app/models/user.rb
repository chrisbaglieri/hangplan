class User < ActiveRecord::Base
  devise :invitable, :database_authenticatable, :registerable, :recoverable, :rememberable, 
    :trackable, :validatable, :omniauthable
  has_and_belongs_to_many :plans
  has_many :subscriptions
  has_many :followed_users, :through => :subscriptions
  has_many :subscribers, :class_name => 'User', :finder_sql => proc { 
    "SELECT u.* FROM users u INNER JOIN subscriptions s ON s.user_id = u.id WHERE s.followed_user_id = #{id}" }
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name
  validates_uniqueness_of :email
  validates_presence_of :name
  
  before_create do |user|
    user.mobile_key = SecureRandom.hex(16)
  end

  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    data = access_token['extra']['user_hash']
    if user = User.find_by_email(data['email'])
      user
    else
      user = User.create!(:email => data['email'], :name => data['name'], :password => SecureRandom.hex(8))
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["user_hash"]
        user.email = data["email"]
      end
    end
  end

   def generate_mobile_key!
    update_attribute :mobile_key, SecureRandom.hex(16)
  end
  
  def friends_plans
    
  end
  
  def plans_near(lat, lon, distance)
    plans = self.plans.near([lat, lon], distance)
    render :json => plans
  end
  
end
