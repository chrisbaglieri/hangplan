class Facebook < Identity
  validates_inclusion_of :source, :in => %w( facebook )
  
  def initialize(attributes=nil)
    super(attributes)
    self.source = "facebook"
  end
end