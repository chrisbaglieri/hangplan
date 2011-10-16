class Plan < ActiveRecord::Base
  belongs_to :owner, :class_name => "User", :foreign_key => :user_id
  attr_accessible :name, :location, :time, :latitude, :longitude, :sponsored, :tentative, :link
  has_and_belongs_to_many :users
  before_create :add_owner_as_participant
  geocoded_by :location
  after_validation :geocode
  
  private
  
  def add_owner_as_participant
    users << owner
  end
end
