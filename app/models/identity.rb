class Identity < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :source, :identifier, :access_token
  attr_accessible :source, :identifier, :access_token
end