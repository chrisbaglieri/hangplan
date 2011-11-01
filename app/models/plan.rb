class Plan < ActiveRecord::Base
  belongs_to :owner, :class_name => "User", :foreign_key => :user_id
  has_many :participants, :dependent => :destroy
  has_many :users, :through => :participants
  attr_accessible :name, :location, :date, :latitude, :longitude, :sponsored, :tentative, :link
  geocoded_by :location
  validates_presence_of :name, :owner
  after_validation :geocode
  before_create :add_owner_as_participant
  
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
