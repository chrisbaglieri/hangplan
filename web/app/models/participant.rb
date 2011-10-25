class Participant < ActiveRecord::Base
  belongs_to :user
  belongs_to :plan
  validates_inclusion_of :points, :in => -1..1
  validates_uniqueness_of :user_id, :scope => :plan_id 
end
