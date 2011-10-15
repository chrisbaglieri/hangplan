class Plan < ActiveRecord::Base
  belongs_to :owner, :class_name => "User", :foreign_key => :user_id
  attr_accessible :name, :location, :time, :latitude, :longitude, :sponsored, :tentative, :link
end
