module PlansHelper

  def format_plan_start(p)
    if p.start_at.nil?
      t 'plans.when.ever'
    else 
      p.start_at.strftime('%A %m/%d/%Y %I:%M%P %Z')
    end
  end
  
  def time_choices
    @time_choices ||= generate_time_choices
    @time_choices
  end
  
  # Used by plans#index in the group headers.
  def format_plan_date(p)
    if p.start_at.nil?
      t 'plans.when.ever'
    elsif p.start_at.today?
      t 'plans.when.today'
    elsif p.start_at.yesterday.today?
      t 'plans.when.tomorrow'
    else
      p.start_at.strftime('%A %m/%d/%Y')
    end
  end
  
  # Used by plans#index in the When column.
  def format_plan_times(p)
    if p.start_at.nil?
      t 'plans.when.ever'
    else
      p.start_at.strftime('%I:%M%P')
    end
  end
  
  private 
  
  def generate_time_choices
    choices = []  # [ ['whenever', ''] ]
    (0..23).each do |h|
      ['00', '30'].each do |m|
        choices << [ "#{h == 0 ? 12 : h<13 ? h : h-12}:#{m}#{h<12 ? 'am' : 'pm'}", "#{h}:#{m}" ]
      end
    end
    choices
  end
  
end
