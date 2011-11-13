class Plan < ActiveRecord::Base
  geocoded_by :location
  
  belongs_to :owner, :class_name => "User", :foreign_key => :user_id
  has_many :participants, :dependent => :destroy
  has_many :users, :through => :participants
  has_many :comments, :dependent => :destroy
  validates_presence_of :name, :owner
  validates_inclusion_of :privacy, :in => %w( public private )
  validate :validate_start_at
  validate :validate_end_at
  after_validation :geocode
  before_create :add_owner_as_participant
  attr_accessible :name, :location, :date, :tentative, :link, :start_date_s, :start_time_s, :end_time_s, :privacy, :description
  
  default_scope :order => :start_at
  
  scope :on_or_after, lambda { |date| where("start_at >= ?", date) }
  scope :on_or_before, lambda { |date| where("start_at <= ?", date) }
  scope :confirmed, where(:tentative => false)
  scope :unconfirmed, where(:tentative => true)
  
  scope :visible, lambda { |user|
    users = user.friends
    users << user
    plans = Plan.where{{ user_id.in => users }}
    plans.reject! { |plan| plan.owner != user and plan.privacy == 'private' }
    plans
  }
  
  def participant?(user)
    self.users.include?(user)
  end
  
  def owner?(user)
    self.owner == user
  end
  
  def visible?(user)
    self.owner?(user) ||
    self.participant?(user) ||
    (self.privacy == 'public' && self.owner.friend_with?(user))
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
  
  def end_time_s
    @end_time_s ||= self.end_at.strftime('%H:%M') if self.end_at
    @end_time_s
  end
  
  def end_time_s=(s)
    @end_time_s = s
  end
  
  private
  
  def add_owner_as_participant
    users << owner
  end
  
  def validate_start_at
    if @start_date_s.blank?
      self.start_at = nil
    else
      self.start_at = Date.strptime(@start_date_s, '%m/%d/%Y').beginning_of_day
      unless @start_time_s.blank?
        # Parse and change the date manually because strftime doesn't 
        # do time zones or daylight savings.
        h, m = @start_time_s.split(':')
        self.start_at = self.start_at.change(:hour => h.to_i, :min => m.to_i)
      end
    end
  rescue ArgumentError
    errors.add(:start_date_s, "is invalid")
  end
  
  def validate_end_at
    # end_at = start date + end time
    if @end_time_s.blank?
      self.end_at = nil
    else
      # Parse and change the date manually because strftime doesn't 
      # do time zones or daylight savings.
      d = Date.strptime(@start_date_s, '%m/%d/%Y').beginning_of_day
      h, m = @end_time_s.split(':')
      self.end_at = d.change(:hour => h.to_i, :min => m.to_i)
    end
  rescue ArgumentError
    errors.add(:start_date_s, "is invalid")
  end
end
