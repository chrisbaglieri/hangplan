class Plan < ActiveRecord::Base
  belongs_to :owner, :class_name => "User", :foreign_key => :user_id
  attr_accessible :name, :location, :time, :latitude, :longitude, :sponsored, :tentative, :link
  has_many :participants
  has_many :users, :through => :participants
  before_create :add_owner_as_participant
  geocoded_by :location
  after_validation :geocode
  
  def participant?(user)
    self.users.include?(user)
  end
  
  private
  
  def add_owner_as_participant
    users << owner
  end
end
