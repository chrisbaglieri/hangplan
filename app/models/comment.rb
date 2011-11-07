class Comment < ActiveRecord::Base
  belongs_to :plan
  belongs_to :user
  validates_presence_of :plan, :user, :message
  default_scope :order => 'created_at DESC'
end
