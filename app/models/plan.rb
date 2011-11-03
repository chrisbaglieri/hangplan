class Plan < ActiveRecord::Base
  belongs_to :owner, :class_name => "User", :foreign_key => :user_id
  has_many :participants, :dependent => :destroy
  has_many :users, :through => :participants
  attr_accessible :name, :location, :date, :latitude, :longitude, :sponsored, 
    :tentative, :link, :start_date_s, :start_time_s
  geocoded_by :location
  validates_presence_of :name, :owner
  validate :check_date_parse_errors
  after_validation :geocode
  before_create :add_owner_as_participant
  before_save :merge_date_fields
  
  scope :after, lambda { |date| where("start_at >= ?", date) }
  scope :before, lambda { |date| where("start_at <= ?", date) }
  scope :confirmed, where(:tentative => false)
  scope :unconfirmed, where(:tentative => true)
  
  def participant?(user)
    self.users.include?(user)
  end
  
  def owner?(user)
    self.owner == user
  end
  
  def start_date_s
    @start_date_s ||= self.start_at.strftime('%m/%d/%Y') if self.start_at
    @start_date_s
  end
  
  def start_date_s=(s)
    @start_date_s = s
  end
  
  def start_time_s
    @start_time_s ||= self.start_at.strftime('%H:%M') if self.start_at
    @start_time_s
  end
  
  def start_time_s=(s)
    @start_time_s = s
  end
  
  private
  
  def add_owner_as_participant
    users << owner
  end
  
  def check_date_parse_errors
    unless @start_date_s.blank?    
      self.start_at = Date.strptime(@start_date_s, '%m/%d/%Y')
      if @start_time_s.blank?
        logger.debug('wtf')
        self.start_at = self.start_at.beginning_of_day
      else
        h, m = @start_time_s.split(':')
        self.start_at = self.start_at.change(:hour => h.to_i, :min => m.to_i)
      end
    end
  rescue ArgumentError
    errors.add(:start_date_s, "is invalid")
  end
  
  def merge_date_fields
  end
end
