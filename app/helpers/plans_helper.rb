module PlansHelper

  def format_plan_start(p)
    if p.start_at.nil?
      return 'whenever'
    else 
      p.start_at.strftime('%A %m/%d/%Y %I:%M%P %Z')
    end
  end
  
  def time_choices
    @time_choices ||= generate_time_choices
    @time_choices
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
