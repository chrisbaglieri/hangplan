class Plan < ActiveRecord::Base
  belongs_to :owner, :class_name => "User", :foreign_key => :user_id
  attr_accessible :name, :location, :time, :latitude, :longitude, :sponsored, :tentative, :link
  has_many :participants
  has_many :users, :through => :participants
  before_create :add_owner_as_participant
  geocoded_by :location
  after_validation :geocode
  
  scope :future, where('time IS NULL OR time > ?', Time.now).order('time asc')
  
  def participant(user)
    Participant.find_by_plan_id_and_user_id(self.id, user)  
  end
  
  def participant?(user)
    self.users.include?(user)
  end
  
  def owner?(user)
    self.owner == user
  end
  
  private
  
  def add_owner_as_participant
    users << owner
  end
end
