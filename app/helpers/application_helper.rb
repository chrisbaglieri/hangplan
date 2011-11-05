module ApplicationHelper
  def format_date(date_to_format)
    date_to_format.strftime('%A, %m /%d').upcase
  end
  
  def format_time(time_to_format)
    time_to_format.strftime('%I:%M %p').upcase
  end
end
