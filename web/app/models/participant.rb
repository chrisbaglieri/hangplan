class Participant < ActiveRecord::Base
  belongs_to :user
  belongs_to :plan
  attr_accessible :points
  validates_inclusion_of :points, :in => -1..1
  validates_uniqueness_of :user_id, :scope => :plan_id 
  validates_presence_of :plan, :user
end
