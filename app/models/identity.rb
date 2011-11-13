class Identity < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :source, :identity, :access_token
  validates_inclusion_of :source, :in => %w( facebook twitter )
  attr_accessible :source, :identity, :access_token
end